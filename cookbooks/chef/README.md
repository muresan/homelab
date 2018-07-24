# ~/Lab - Chef Server Cookbook

## About

This cookbook will provision a new Chef server in the environment.  If it is a worker instance downstream from another Chef server it will automatically replicate configuration metadata from that node.

See the [recipes](./recipes) and [attributes](./attributes) for more detail of the objects managed by this cookbook.

**NOTICE** *These cookbooks do not have a default.rb, this is intentional.  Use wrapper
cookbooks to consume the recipes instead.  See the lab_management cookbook and
the readme in the root of this project for more information.*

**WARNING:** *These cookbooks should not be used for production without additional modification.*

## License

Copyright 2013-2018, Andrew Wyatt

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.