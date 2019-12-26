# AMI-selector AWS Module
The ami-selector module will find a valid AMI id for a given region.

#### Optional
| name | type | comment
| --------- | --------- | ----------
| most_recent | boolean | A flag to use the most recent image. (default: true)
| owners | Array<string> | A list of AWS owner ids.
| name | string | The name of the AMI image to search for. (CentOS Linux 7 x86_64*)

### Output
| name | type | comment
| --------- | --------- | ----------
| image_id | string | An AMI id for the given region.
