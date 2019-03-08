use strict;
use warnings FATAL => 'all';
use 5.006;

if (!-f 'META.yml') {
  require JSON::PP;
  require Data::Dumper;

  my $my_module_data = JSON::PP::decode_json(
      scalar `curl -s 'https://fastapi.metacpan.org/v1/release/latest_by_author/HAARG'`
  );

  my @modules =
    sort
    map { s/-/::/g; $_ }
    map { $_->{distribution} }
    @{ $my_module_data->{releases} };

  open my $fh, '>', 'my_modules'
    or die "can't create my_modules: $!";
  $Data::Dumper::Indent = $Data::Dumper::Indent = 1;
  $Data::Dumper::Terse = $Data::Dumper::Terse = 1;
  print $fh Data::Dumper::Dumper(\@modules);
  close $fh;
}

my %META = (
  name => 'Task-BeLike-HAARG',
  license => 'perl_5',
  dynamic_config => 0,
  prereqs => {
    configure => { requires => {
      'ExtUtils::MakeMaker'   => 0,
    } },
    build => { requires => {
    } },
    test => { requires => {
    } },
    runtime => {
      requires => {
        map +($_ => 0), qw(
          ExtUtils::MakeMaker
          Test::Harness
          Module::Build
          Module::Build::Tiny
          ExtUtils::CBuilder
          File::Temp
          File::Spec
          Test::More
          Data::Dumper
          IO::Compress::Base
          Compress::Zlib
          IO::Zlib
          Archive::Tar
          Archive::Tar::Wrapper
          Archive::Zip
          Digest::SHA
          File::HomeDir
          Net::FTP
          Term::ReadKey
          Term::ReadLine::Perl
          Parse::CPAN::Meta
          Text::Glob
          CPAN
          File::Which
          IO::Tty
          Expect
          Module::Signature
          CPAN::Reporter
          Kwalify
          CPAN::SQLite

          Devel::PatchPerl

          strictures
          indirect
          multidimensional
          bareword::filehandles

          Safe::Isa
          curry
          Import::Into

          JSON
          JSON::XS
          Cpanel::JSON::XS
          JSON::MaybeXS
          YAML
          YAML::XS

          Plack
          Starman
          Gazelle

          AnyEvent
          Coro
          Twiggy
          EV
          Feersum

          Moose

          Dist::Zilla
          Dist::Zilla::Plugin::Git
          Dist::Zilla::Plugin::PodWeaver
          Dist::Zilla::PluginBundle::Author::ETHER

          Moo
          MooX::Types::MooseLike
          MooX::HandlesVia
          Type::Tiny

          App::FatPacker
          Object::Remote

          Carp::Always
          Devel::Dwarn
          Devel::NYTProf
          Dumbbench
          App::Nopaste

          DBIx::Class
          Catalyst::Devel

          LWP
          LWP::Protocol::https
          Daemon::Control
          Module::CoreList

          Module::Install
          Module::Install::Repository
          Module::Install::ExtraTests

          App::cpm
          App::cpanoutdated
          CPAN::Uploader
        ),
        @{ do('./my_modules') || [] },
      },
    },
    develop => {
      requires => {
      },
    },
  },
  resources => {
    repository => {
      url => 'https://github.com/haarg/Task-BeLike-HAARG.git',
      web => 'https://github.com/haarg/Task-BeLike-HAARG',
      type => 'git',
    },
    bugtracker => {
      web => 'https://github.com/haarg/Task-BeLike-HAARG/issues',
    },
    license => [ 'http://dev.perl.org/licenses/' ],
  },
  no_index => {
    directory => [ 't', 'xt' ]
  },
);

my %MM_ARGS = ();

sub MY::install {
    return '';
}

## BOILERPLATE ###############################################################
require ExtUtils::MakeMaker;
(do './maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

# have to do this since old EUMM dev releases miss the eval $VERSION line
my $eumm_version  = eval $ExtUtils::MakeMaker::VERSION;
my $mymeta        = $eumm_version >= 6.57_02;
my $mymeta_broken = $mymeta && $eumm_version < 6.57_07;

($MM_ARGS{NAME} = $META{name}) =~ s/-/::/g;
($MM_ARGS{VERSION_FROM} = "lib/$MM_ARGS{NAME}.pm") =~ s{::}{/}g;
$META{license} = [ $META{license} ]
  if $META{license} && !ref $META{license};
$MM_ARGS{LICENSE} = $META{license}[0]
  if $META{license} && $eumm_version >= 6.30;
$MM_ARGS{NO_MYMETA} = 1
  if $mymeta_broken;
$MM_ARGS{META_ADD} = { 'meta-spec' => { version => 2 }, %META }
  unless -f 'META.yml';
$MM_ARGS{PL_FILES} ||= {};
$MM_ARGS{NORECURS} = 1
  if not exists $MM_ARGS{NORECURS};

for (qw(configure build test runtime)) {
  my $key = $_ eq 'runtime' ? 'PREREQ_PM' : uc $_.'_REQUIRES';
  my $r = $MM_ARGS{$key} = {
    %{$META{prereqs}{$_}{requires} || {}},
    %{delete $MM_ARGS{$key} || {}},
  };
  defined $r->{$_} or delete $r->{$_} for keys %$r;
}

$MM_ARGS{MIN_PERL_VERSION} = delete $MM_ARGS{PREREQ_PM}{perl} || 0;

delete $MM_ARGS{MIN_PERL_VERSION}
  if $eumm_version < 6.47_01;
$MM_ARGS{BUILD_REQUIRES} = {%{$MM_ARGS{BUILD_REQUIRES}}, %{delete $MM_ARGS{TEST_REQUIRES}}}
  if $eumm_version < 6.63_03;
$MM_ARGS{PREREQ_PM} = {%{$MM_ARGS{PREREQ_PM}}, %{delete $MM_ARGS{BUILD_REQUIRES}}}
  if $eumm_version < 6.55_01;
delete $MM_ARGS{CONFIGURE_REQUIRES}
  if $eumm_version < 6.51_03;

ExtUtils::MakeMaker::WriteMakefile(%MM_ARGS);
## END BOILERPLATE ###########################################################
