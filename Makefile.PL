use strict;
use ExtUtils::MakeMaker;
use JSON::PP;
my $my_module_data = JSON::PP::decode_json(
    scalar `curl -s 'http://api.metacpan.org/v0/release/_search?q=author:HAARG&filter=status:latest&fields=name,status&size=100'`
);
my @modules =
    map { my $n = $_->{name}; $n =~ s/-[\d._]+$//; $n =~ s/-/::/g; $n }
    grep { $_->{status} eq 'latest' }
    map { $_->{fields} }
    @{ $my_module_data->{hits}{hits} };

WriteMakefile(
    NAME => 'Task::BeLike::HAARG',
    VERSION => '0.00100',
    ABSTRACT => 'stuff',

    PREREQ_PM => { map { ( $_ => 0 ) } @modules, qw(
        Bundle::CPANxxl
        CPAN::SQLite

        Carp::Always
        strictures
        indirect
        multidimensional
        bareword::filehandles

        JSON::XS
        JSON
        YAML
        YAML::XS

        Plack
        AnyEvent
        Starman

        Moose

        Dist::Zilla
        Dist::Zilla::Plugin::Git
        Dist::Zilla::Plugin::PodWeaver

        Moo
        MooX::Types::MooseLike

        App::FatPacker
        Object::Remote

        Devel::Dwarn
        Devel::NYTProf
        Dumbbench
        App::Ack

        DBIx::Class
        Catalyst::Devel

        LWP
        Daemon::Control
        Module::CoreList

        Module::Install
        Module::Install::Repository
        Module::Install::ExtraTests
    )},
);

sub MY::install {
    return '';
}
