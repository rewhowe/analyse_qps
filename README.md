# Analyse QPS

Takes a list of datetimes and calculates QPS.

The input file should be a simple list of datetimes in `YYYY-MM-DD HH:ii:ss` or `YYYY/MM/DD HH:ii:ss` format, one per line. These can be optionally quoted (for example, if the source was a csv).

This script can be useful when pulling specific logs not already tracked by monitoring systems, local logs, or even data files which contain datetimes. The date format is usually easy to extract via the `cut` command, or any sort of regex.

Example with several formats:

```
2024-12-29 00:03:08
2024-12-29 00:29:02
2024/12/30 00:32:06
2024/12/30 00:32:48
2024-12-29 00:35:11
2024-12-29 00:49:28
"2024-12-31 00:57:02"
"2024-12-31 01:03:13"
"2024-12-31 01:09:50"
2024-12-29 01:24:35
2024-12-29 00:35:11
2024-12-30 00:32:48
```

The output is simply sent to stdout and gives the totals by day and totals by hour in x-y coordinates for easy graphing, and average and max for each unit of day, hour, minute, and second.

## Usage

```shell
perl analyse_qps.pl /path/to/input/file
```

## Example

```shell
$ perl analyse_qps.pl request_log.txt
Totals By Day:
2024-12-01,2385
2024-12-02,14057
2024-12-03,5555
2024-12-04,4610
2024-12-05,7567
2024-12-06,5629
2024-12-07,2746
2024-12-08,2591
2024-12-09,1821
2024-12-10,1785
2024-12-11,2391
2024-12-12,1832
2024-12-13,5505
2024-12-14,5922
2024-12-15,3790
2024-12-16,2609
2024-12-17,2683
2024-12-18,3166
2024-12-19,2153
2024-12-20,2056
2024-12-21,2831
2024-12-22,1928
2024-12-23,1613
2024-12-24,1385
2024-12-25,2432
2024-12-26,1779
2024-12-27,1706
2024-12-28,1735
2024-12-29,1513
2024-12-30,1358
2024-12-31,1525
Average By Hour:
09,6.48387096774194
10,210.870967741935
11,202
12,282
13,193.612903225806
14,229.935483870968
15,259
16,305.838709677419
17,345.161290322581
18,330.838709677419
19,416.645161290323
20,462.548387096774
21,2.95454545454545
Statistics:
Day: 100658 / 31 = 3247.03225806452, max: 14057
Hour: 100658 / 394 = 255.477157360406, max: 1623
Minute: 100658 / 18691 = 5.38537263923814, max: 62
Second: 100658 / 92686 = 1.0860108322724, max: 6
```
