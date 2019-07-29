#!/usr/bin/env perl
# ./generate.pl 'email@example.com' '555-867-5309'

use 5.016_000;
use warnings;
use autodie qw/:file :io/;

use FindBin qw/$Bin/;
use File::Spec;

my ($EMAIL, $PHONE) = @ARGV;

# might need another one for the .cls file
my $template_file = File::Spec->catfile($Bin, 'template.tex');
my $output_file = File::Spec->catfile($Bin, 'resume-scott-lanning.tex');

{
    open(my $rh, '<', $template_file);
    open(my $wh, '>', $output_file);

    my $phone = format_phone($PHONE);

    while (<$rh>) {
        s/<EMAIL>/$EMAIL/g;
        s/<PHONE>/$phone/g;
        print $wh $_;
    }
} # close filehandles

exit;

sub format_phone {
    my ($phone) = @_;

    $phone =~ tr/0-9//cd;   # keep only digits
    if ($phone =~ /\A([0-9]{3})([0-9]{3})([0-9]{4})\z/) {  # US number w/area code
        return("+1 ($1)$2-$3");
    }
    else {
        die "phone number (was: $phone) should be 10 digits\n";
    }
}
