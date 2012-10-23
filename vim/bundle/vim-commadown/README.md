# Whoa, whoa, whoa. Comma down.

Comma down is a vim plugin that allows you to select a block of text and make sure each line has a comma at the end but the last. This is useful when you sort a long list and want to make sure all the commas are in the right places.

## Usage

If you're in visual mode and enter command mode your prompt should include `'<,'>` which allows any function you call access to the selected text. Just use `call CommaDown()` and the selected will be fixed.

## Example

If you select this text:

```
one
two,
three,
four,
```

And run `:'<,'>call Commadown()` you will get:


```
one,
two,
three,
four
```

## Acknowledgements

[Ali Aghareza](https://github.com/aghareza) for telling me to calm down so much.
