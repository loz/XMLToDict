# XMLToDict

A simple library to convert XML data into an NSDictionary.  This is useful if
you have a life and would like to use it not parsing XML.

## Using It

Simply include `XMLToDict.h` in the place you want it then:

```objectivec
  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http:/example.com/foo.xml"]];
  NSDictionary *niceData = [XMLToDict dictFromData:data];
```

You now have a nice dictionary to access the data.

Nodes names are the keys for the dictionary and the will map to:
* NSString Text value (if there are no child nodes or attributes
* NSDictionary containing attributes, Child Nodes and @"text" key for key content
  if there are attributes
* NSArray of objects if the key occurs repeatedly in a set of nodes

## Example

```xml
<doc>
  <list of='items'>
    <item>one</item>
    <item>two</item>
    <item>three</item>
  </list>
  <thing is='ace'>with text</thing>
</doc>
```

The above XML will result in a dictionary which can would look like so in
JSON:

```json
{
  'doc' => {
    'list' => {
      'of' => 'items',
      'item' => [
        'one',
        'two',
        'three'
      ]
    },
    'thing' => {
      'is' => 'ace',
      'text' => 'with text'
    }
  }
}
```

## Disclaimer

I am not an XML guru.  I, probably like you, hate it and want it out of my
face as quickly as possible.  Therefore this library might not parse stuff
you might care about, but it should probably do the trick.

If there's issues with XML you're forced to deal with, then feel free to
submit a pull request to fix it.

