use warnings;
use strict;

my $charges = {
  # $day => {
  #   total => xxx
  #   hours => {
  #     $hour => {
  #       total => xxx
  #       minutes => {
  #         $minute => {
  #           total => xxx
  #           seconds => {
  #             $second => xxx
  #           }
  #         }
  #       }
  #     }
  #   }
  # }
};

open my $f, '<', $ARGV[0] or die;

foreach my $line (<$f>) {
  my ($date, $hour, $minute, $second) = (
    $line =~ /"?
      (\d{4}[-\/]\d{2}[-\/]\d{2})  # YYYY-MM-DD
      \s
      (\d\d):(\d\d):(\d\d)         # HH:ii:ss
    "?/msx
  );

  $date =~ s/\//-/gmsx;
  $charges->{$date} ||= { total => 0, hours => {} };
  $charges->{$date}->{total} += 1;

  $charges->{$date}->{hours}->{$hour} ||= { total => 0, minutes => {} };
  $charges->{$date}->{hours}->{$hour}->{total} += 1;

  $charges->{$date}->{hours}->{$hour}->{minutes}->{$minute} ||= { total => 0, seconds => {} };
  $charges->{$date}->{hours}->{$hour}->{minutes}->{$minute}->{total} += 1;

  $charges->{$date}->{hours}->{$hour}->{minutes}->{$minute}->{seconds}->{$second} ||= 0;
  $charges->{$date}->{hours}->{$hour}->{minutes}->{$minute}->{seconds}->{$second} += 1;
}

close $f;

my $days_total = 0;
my $days_num   = 0;
my $days_max   = 0;

my $hours_total = 0;
my $hours_num   = 0;
my $hours_max   = 0;

my $totals_by_hour = {};

my $minutes_total = 0;
my $minutes_num   = 0;
my $minutes_max   = 0;

my $seconds_total = 0;
my $seconds_num   = 0;
my $seconds_max   = 0;

print "Totals By Day:\n";

foreach my $day (sort keys %{$charges}) {
  my $day_total = $charges->{$day}->{total};

  $days_total += $day_total;
  $days_num   += 1;
  $days_max    = $day_total if $day_total > $days_max;

  print "$day,$day_total\n";

  foreach my $hour (keys %{$charges->{$day}->{hours}}) {
    my $hour_total = $charges->{$day}->{hours}->{$hour}->{total};

    $hours_total += $hour_total;
    $hours_num   += 1;
    $hours_max    = $hour_total if $hour_total > $hours_max;

    $totals_by_hour->{$hour} ||= [];
    push @{$totals_by_hour->{$hour}}, $hour_total;

    foreach my $minute (keys %{$charges->{$day}->{hours}->{$hour}->{minutes}}) {
      my $minute_total = $charges->{$day}->{hours}->{$hour}->{minutes}->{$minute}->{total};

      $minutes_total += $minute_total;
      $minutes_num   += 1;
      $minutes_max    = $minute_total if $minute_total > $minutes_max;

      foreach my $second (keys %{$charges->{$day}->{hours}->{$hour}->{minutes}->{$minute}->{seconds}}) {
        my $second_total = $charges->{$day}->{hours}->{$hour}->{minutes}->{$minute}->{seconds}->{$second};

        $seconds_total += $second_total;
        $seconds_num   += 1;
        $seconds_max    = $second_total if $second_total > $seconds_max;
      }
    }
  }
}

print "Average By Hour:\n";

foreach my $hour (sort keys %{$totals_by_hour}) {
  my $totals_sum = 0;
  $totals_sum += $_ foreach @{$totals_by_hour->{$hour}};
  my $totals_num = @{$totals_by_hour->{$hour}};
  print "$hour,@{[ $totals_sum / $totals_num ]}\n";
}

print "Statistics:\n";
print "Day: $days_total / $days_num = @{[ $days_total / $days_num ]}, max: $days_max\n";
print "Hour: $hours_total / $hours_num = @{[ $hours_total / $hours_num ]}, max: $hours_max\n";
print "Minute: $minutes_total / $minutes_num = @{[ $minutes_total / $minutes_num ]}, max: $minutes_max\n";
print "Second: $seconds_total / $seconds_num = @{[ $seconds_total / $seconds_num ]}, max: $seconds_max\n";
