#!/usr/bin/perl
use strict;
use warnings;

use Encode;
use Cwd;
use File::Basename;
    
package xLang;

our $language = {};
my $default = '';

sub initialize
{
    my $directory = Cwd::getcwd() . '/Lang';

    opendir (my $dir, $directory)
        or return 0;
    
    while (my $file = readdir($dir))
    {
        my $module = File::Basename::basename($file);
        if ($module eq '.' || $module eq '..')
        {
            next;
        }
        
        $module = 'Lang/' . $module;
        require $module;
    }
    
    closedir($dir);
        
    return 1;
}

sub setDefault
{
    $default = shift;
}

sub isValid
{
    my $lang = shift;
    
    if (!exists $::language{$lang})
    {
        return $default;
    }
    
    return $lang;
}

sub get
{
    my($lang, $index) = @_;
    
    if (!exists $::language{$lang})
    {
        return xLang::get($default, $index);
    }
    
    if (!exists $::language{$lang}{$index})
    {
        return $index;
    }
    
    return Encode::encode_utf8($::language{$lang}{$index});
}

1

__END__
