use strict;
use ExtUtils::MakeMaker;

WriteMakefile (
  AUTHOR        => 'Casey West <casey@geeknest.com>',
  ABSTRACT      => "Email::Folder Access to POP3 Folders",
  NAME          => 'Email::Folder::POP3',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Email::Folder' => '0.84',
    'Email::FolderType::Net' => '1.02',
    'Net::POP3' => '2.28',
    'Test::More' => '0.47',
    'URI' => '1.35',
  },
  VERSION_FROM  => 'lib/Email/Folder/POP3.pm',
);
