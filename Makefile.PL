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
    VERSION => '0.001000',
    ABSTRACT => 'Modules haarg uses or wrote',

    PREREQ_PM => { map { ( $_ => 0 ) } @modules, qw(
        Bundle::CPANxxl
        CPAN::SQLite

        strictures
        indirect
        multidimensional
        bareword::filehandles

        Safe::Isa
        curry
        Import::Into

        JSON::XS
        JSON
        JSON::MaybeXS
        YAML
        YAML::XS

        Plack
        Starman

        AnyEvent
        Coro
        Twiggy

        Moose

        Dist::Zilla
        Dist::Zilla::Plugin::Git
        Dist::Zilla::Plugin::PodWeaver
        Dist::Zilla::PluginBundle::Author::ETHER

        Moo
        MooX::Types::MooseLike
        MooX::HandlesVia

        App::FatPacker
        Object::Remote

        Carp::Always
        Devel::Dwarn
        Devel::NYTProf
        Dumbbench

        DBIx::Class
        Catalyst::Devel

        LWP
        LWP::Protocol::https
        Daemon::Control
        Module::CoreList

        Module::Install
        Module::Install::Repository
        Module::Install::ExtraTests

        App::cpanoutdated
        CPAN::Uploader
    )},
);

sub MY::install {
    return '';
}
