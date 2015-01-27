# autopatch-nativex-cookbook

A wrapper cookbook for autopatch.  The goal is to provide Windows support. It may also include extensions to the Linux autopatch.
## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['autopatch-nativex']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### autopatch-nativex::default

Include `autopatch-nativex` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[autopatch-nativex::default]"
  ]
}
```

## License and Authors

Author:: NativeX (<derek.bromenshenkel@nativex.com>)
