use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'LEOCHARRE::CLI2',
   VERSION_FROM => 'lib/LEOCHARRE/CLI2.pm',
   

   # gen /usr/bin/pmused by Wed Mar 18 14:49:10 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Devel::Symdump'                    => '2.07',
      'Exporter'                          => '5',
      'Getopt::Std'                       => '1.05',
      'Getopt::Std::Strict'               => '1.01',
      'LEOCHARRE::DEBUG'                  => '1.12',
      'LEOCHARRE::Dir'                    => '1.06',
      'Smart::Comments'                   => '1',
      'Test::Simple'                      => '0',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [],
);


