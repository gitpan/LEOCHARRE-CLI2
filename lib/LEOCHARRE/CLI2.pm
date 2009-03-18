package LEOCHARRE::CLI2;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %OPT @OPT_KEYS $OPT_STRING %ARGV);
use Exporter;
use Carp;
use Cwd;
use strict;
use Getopt::Std;

my @export_argv = qw/argv_files argv_files_count argv_dirs argv_dirs_count argv_cwd/;
@ISA = qw(Exporter);
@EXPORT_OK = ( qw/yn/, @export_argv );
%EXPORT_TAGS = ( argv => \@export_argv, all => \@EXPORT_OK, );
$VERSION = sprintf "%d.%02d", q$Revision: 1.4 $ =~ /(\d+)/g;

#use Smart::Comments '###';


sub import {
   my $class = shift;

   # find the opt string
   import_resolve_opt_string(\@_);
   import_make_opts();
   
   _init_env_ext();


   no strict 'refs';
   main->can('debug') or *{'main::debug'} = \&debug;
   main->can('usage') or *{'main::usage'} = \&usage;
   ### @_

   __PACKAGE__->export_to_level(1, ( $class, @_));
}


sub import_resolve_opt_string {
   ### finding opt string..   
   my $import_list = shift;

   my @changed_list;
   
   for my $arg ( @$import_list ){
      ### testing arg -----------------
      ### $arg

      my $tag = $arg;
      $tag=~s/^\://;
      
      if( __PACKAGE__->can($arg) or $EXPORT_TAGS{$tag} ){          
         ### arg is a sub or export tag:
         ### $arg
         push @changed_list, $arg; 
         next;
      }
      ### arg is not a sub or export tag


             
      #$opt_string and die("bad args? cant have $arg as export arg?");
      $OPT_STRING = $arg;      
      ### $OPT_STRING
   }

   # replace the import list
   @$import_list = @changed_list;

   # note that this does NOT replace the list: 
   # $import_list = \@changed_list
   # it just changes the reference! ;-)


   ### $import_list

   
   
}

sub _init_env_ext {

   $0=~/([^\/]+)$/;
   $ENV{SCRIPT_FILENAME} = $1;

}


sub import_make_opts {
   
   for my $l ( qw/h d v/ ){
      $OPT_STRING=~/$l/ or $OPT_STRING.=$l;
   }


   no strict 'refs';   
   *{'main::OPT'}  = \%OPT;
   *{'main::OPT_STRING'}  = \$OPT_STRING;


   require Getopt::Std;
   Getopt::Std::getopts($OPT_STRING, \%OPT);   
   
   my $_opt_string = $OPT_STRING;
   $_opt_string=~s/\W//g;
   @OPT_KEYS = split(//, $_opt_string);
   ## @OPT_KEYS
   
   # make variables
   for my $opt_key (@OPT_KEYS){
      *{"main\::opt_$opt_key"} = \$OPT{$opt_key};
   }

   

}




# ARGV ----- begin
sub _argv {
   defined %ARGV or _init_argv();
   if (my $key = shift){
      return $ARGV{$key};
   }
   \%ARGV;
}
      
sub _init_argv { 

   my @_argv;
   my(@files,$files_count, @dirs, $dirs_count);

   ### -------------------------------- init argv paths
   for my $arg ( @ARGV ){   
      defined $arg or next;
      ### testing for disk arg
      ### $arg
      
      my ($isf, $isd) = ( -f $arg, -d $arg );

      unless( $isf or $isd ){

         ### arg -f/-d no         
         push @_argv, $arg; # leave alone
         next;
      }

      require Cwd;
      my $abs = Cwd::abs_path($arg);

      $isf and (push @files, $abs) and next;
      push @dirs, $abs;
   }

   if( $ARGV{DIRS_COUNT} = ( (scalar @dirs)  || 0 ) ){
      $ARGV{DIRS} = \@dirs;
      $ARGV{CWD} = $dirs[0];   
   }
   else {
      $ARGV{CWD}= Cwd::abs_path('./');
   }

   if( $ARGV{FILES_COUNT} = ( (scalar @files) || 0 ) ){
      $ARGV{FILES} = \@files;
   }

   ### %ARGV

   
   @ARGV = @_argv;
}


sub argv_files { _argv('FILES') or return; @{_argv('FILES')} }
sub argv_files_count { _argv('FILES_COUNT') }
sub argv_dirs { _argv('DIRS') or return; @{_argv('DIRS')} }
sub argv_dirs_count { _argv('DIRS_COUNT') }
sub argv_cwd { _argv('CWD') }
   

# end argv------------




INIT {
   ### LEOCHARRE CLI2 INIT
   $main::opt_h 
      and print &main::usage 
      and exit;
   $main::opt_v 
      and print $main::VERSION 
      and exit;
}


sub debug { $main::opt_d and warn(" # $ENV{SCRIPT_FILENAME}, @_\n"); 1 }


sub yn {
        my $question = shift; 
        $question ||='Your answer? ';
        my $val = undef;
        until (defined $val){
                print "$question (y/n): ";
                $val = <STDIN>;
                chomp $val;
                if ($val eq 'y'){ $val = 1; }
                elsif ($val eq 'n'){ $val = 0;}
                else { $val = undef; }
        }
        return $val;
}


# auto generated usage
sub usage {


   my $out = "$ENV{SCRIPT_FILENAME} [OPTION]...\n\n";

   for my $opt ( sort keys %OPT ){
      my $desc = 
         $opt eq 'h' ? 'help' :
         $opt eq 'd' ? 'debug' :
         $opt eq 'v' ? 'version' : '';

      $out.="\t-$opt\t\t$desc\n";
   }

   "$out\n";
}





1;


__END__


   use LEOCHARRE::CLI2 'o:p:t', 'help','version';
