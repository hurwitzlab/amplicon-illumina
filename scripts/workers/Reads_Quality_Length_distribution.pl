#!/usr/bin/perl

# Author: RAHUL SHARMA
# Company: Bik-F, Senckenberg.
# Date: 16th, July 2013
# Version: V1.0
# Code: This code is to generate the length distribution of paired end reads.

###############################
## Libraries Used
###############################

use warnings;
use strict;
use Getopt::Long;  # To get the multiple options;

###############################
## Usgae message
###############################

my $usage="

perl $0 -fw <Foward reads file> -rw <Reverse reads file> -sc <Scoring system used (33 or 64)> -q <Average read quality threshold> -l <Length threshold> -ld <Y/N> 

-fw : File having the forward reads.
-rw : File having the reverse reads.
-sc : Scores used for reads quality (33 - Sanger Phred+33, 64 - Solexa Solexa+64, 64 - Illumina 1.3+ Phred+64, 64 - Illumina 1.5+ Phred+64,       33 - Illumina 1.8+ Phred+33) 
-q  : Quality threshold filter
-l  : length threshold filter
-ld  : Plot length distribution table (Yes or No).
-h  : Help messgae.

# Author: RAHUL SHARMA
# Company: Bik-F, Senckenberg.
# Date: 12th, July, 2013
# Version: V1.0
# Code: This code is to generate the length distribution of paired end reads.

";


###############################
## Options definition
###############################

my ($fw, $rw, $sc, $q, $l, $ld, $help); 

GetOptions ("fw=s" => \$fw,         #gff=s; 's' means it would take a string value as input;   
            "rw=s" => \$rw,
            "sc=i" => \$sc,
            "q=i" => \$q,
            "l=i" => \$l,
            "ld=s" => \$ld,
            "h|help!"  => \$help);           #h! will not take any value;
 
  if ($help) {
         die $usage;
  }

#$L = "Yes";
die "\nAll parameters are required",$usage unless  ($fw && $rw && $sc && $q && $l && $ld);


if ($ld =~ /^Y/i){
length_distribution($fw, $rw);
}

quality($fw, $rw, $sc, $q, $l);


###############################
## Subroutines
###############################


##### Reads having Ns and quality filters

sub quality{

my $fw=$_[0];
my $rw=$_[1];
my $sc=$_[2];
my $q=$_[3];
my $l=$_[4];

open F, "$fw" or die $!;
open R, "$rw" or die $!;
open W, ">Reads_Average_quality_distribution_table.tab" or die $!;
open S, ">Reads_quality_and_reads_having_Ns_summary.txt" or die $!;
open TF, ">Filtered_reads_without_Ns_quality_threshold_$q\_length_threshold_$l\_R1.fastq" or die $!;
open TR, ">Filtered_reads_without_Ns_quality_threshold_$q\_length_threshold_$l\_R2.fastq" or die $!;

my $count=0;
my ($q20, $q24, $q26, $q30)=(0,0,0,0);
my $n=0;
my $qlt=0;

do{

$count++;

## forward reads

chomp (my $f1 = <F>); # Forward reads ID
chomp (my $f2 = <F>); # Forward reads Sequence
my $len1=length($f2); # Forward reads length
chomp (my $f3 = <F>); # Forward reads +
chomp (my $f4 = <F>); # Forward reads quality

## reverse reads

chomp (my $r1 = <R>); # Reverse reads ID 
chomp (my $r2 = <R>); # Reverse reads Sequence
my $len2=length($r2); # Reverse reads length
chomp (my $r3 = <R>); # Reverse reads +
chomp (my $r4 = <R>); # Reverse reads quality

my $fw_avg_qual=quality_chk($f4, $sc);
my $rw_avg_qual=quality_chk($r4, $sc);

      sub quality_chk{

      my @s=split('',$_[0]);
      my $n= length($_[0]);my $p;
      my $sc=$_[1]; my ($sum, $avg)=(0,0);
      foreach my $l(@s)
          {
            $p = ord($l)-$sc; $sum=$p+$sum;
          }
             $avg=$sum/$n;
             return $avg;
            }


#print W ("$f1\t$fw_avg_qual\t$r1\t$rw_avg_qual\n");    

if(($fw_avg_qual >= 20) && ($rw_avg_qual >= 20))
     
      { $q20++;
  
     if(($fw_avg_qual >= 24) && ($rw_avg_qual >= 24))
   
           { $q24++;
   
          if(($fw_avg_qual >= 26) && ($rw_avg_qual >= 26))
     
              { $q26++;
     
             if(($fw_avg_qual >= 30) && ($rw_avg_qual >= 30))
                {
                  $q30++;
                 }
              }
           } 
        }
     
if (($f2 !~ /N/i) && ($r2 !~ /N/i)) 

 {
     $n++;
 if(($fw_avg_qual >= $q) && ($rw_avg_qual >= $q) && ($len1 >= $l) && ($len2 >= $l))
    {
      print TF "$f1\n$f2\n$f3\n$f4\n";  
      print TR "$r1\n$r2\n$r3\n$r4\n";  
      $qlt++;
       }
 }


}until eof(F);

my ($pq20, $pq24, $pq26, $pq30)=(($q20/$count)*100, ($q24/$count)*100, ($q26/$count)*100, ($q30/$count)*100);
my $np=($n/$count)*100;

print S "Reads from files: \"$fw\" and \"$rw\" 
         Total reads were: $count 
         Reads (both F/R having average quality greater than 20): $q20 ($pq20%)
         Reads (both F/R having average quality greater than 24): $q24 ($pq24%)
         Reads (both F/R having average quality greater than 26): $q26 ($pq26%)
         Reads (both F/R having average quality greater than 30): $q30 ($pq30%)
    
         Number of reads without Ns in F/R: $n ($np%) 

Please check the Reads_Average_quality_distribution_table.tab file for reads average quality distribution\n";
close (F);
close (R);
close (W);
close (S);
close (TF);
close (TR);

my $qltp=($qlt/$count)*100;

print "\n\nTotal number of reads: $count
            
           Reads without Ns (F/R): $n ($np%)

           Reads without Ns, quality cutoff $q and length cutoff $l: $qlt ($qltp%)

           This script has generated trimmed files:

           \"Filtered_reads_without_Ns_quality_threshold_$q\_length_threshold_$l\_R1.fastq\"
           \"Filtered_reads_without_Ns_quality_threshold_$q\_length_threshold_$l\_R2.fastq\"
         
           Summary files:            

           \"Reads_Average_quality_distribution_table.tab\"
           \"Reads_quality_and_reads_having_Ns_summary.txt\"
";
}

####### Length distribution

sub length_distribution{

my $fw=$_[0];
my $rw=$_[1];

open F, "$fw" or die $!;
open R, "$rw" or die $!;
open W, ">Reads_length_distribution_table.tab" or die $!;
open S, ">Reads_length_summary.txt" or die $!;

my $count=0;
my ($gtr160, $gtr180, $gtr200, $gtr220, $gtr240)=(0, 0, 0, 0, 0);

do{
## forward reads
$count++;

chomp (my $f1 = <F>); # Forward reads ID
chomp (my $f2 = <F>); # Forward reads Sequence
my $len1=length($f2); # Forward reads length

chomp (my $f3 = <F>); # Forward reads +
chomp (my $f4 = <F>); # Forward reads quality

## reverse reads

chomp (my $r1 = <R>); # Reverse reads ID 
chomp (my $r2 = <R>); # Reverse reads Sequence
my $len2=length($r2); # Reverse reads length

chomp (my $r3 = <R>); # Reverse reads +
chomp (my $r4 = <R>); # Reverse reads quality

print W ("$f1\t$len1\t$r1\t$len2\n");     ### ID

if(($len1 >= 160) && ($len2 >= 160))
    {
       $gtr160++;
    if(($len1 >= 180) && ($len2 >= 180))
       { $gtr180++;
       if(($len1 >= 200) && ($len2 >= 200))
           { $gtr200++;
          if(($len1 >= 220) && ($len2 >= 220))
            { $gtr220++;  
            if(($len1 >= 240) && ($len2 >= 240))
             { 
               $gtr240++;
                }
              }
           } 
        }
     }

}until eof(F);

my ($pg160, $pg180, $pg200, $pg220, $pg240)=(($gtr160/$count)*100, ($gtr180/$count)*100, ($gtr200/$count)*100, ($gtr220/$count)*100, ($gtr240/$count)*100);

print S "Reads from files: \"$fw\" and \"$rw\" 
         Total reads were $count 
         Reads (both F/R greater than 160): $gtr160 ($pg160%)
         Reads (both F/R greater than 180): $gtr180 ($pg180%)
         Reads (both F/R greater than 200): $gtr200 ($pg200%)
         Reads (both F/R greater than 220): $gtr220 ($pg220%)
         Reads (both F/R greater than 240): $gtr240 ($pg240%)

Please check the \"Reads_length_distribution_table.tab\" file for reads length distribution\n";

close (F);
close (R);
close (W);
close (S);
}
