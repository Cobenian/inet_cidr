# InetCidr Changelog

## Version: 1.0.8 (2024-01-10)

```
Misc: Updated links to include Cheatsheet and Changelog
```

## Version: 1.0.7 (2024-01-10)

```
Code: Updated `calc_end_address/1` to return `{:ok, address}` or `{:error, reason}` tuple.
Code: Added `cal_end_address!/1`
Misc: Added Cheatsheet
Docs: Updated README to not use deprecated functions
```

## Version: 1.0.6 (2024-01-10)

```
- Deprecated: InetCidr.parse/1 (Use InetCidr.parse_cidr!/1 instead)
- Deprecated: InetCidr.parse/2 (Use InetCidr.parse_cidr!/2 instead)
- Code: Added InetCidr.parse_cidr/2
- Code: Added InetCidr.parse_cidr!/2
- Code: Added InetCidr.parse_address/1 which complements the existing InetCidr.parse_address!/1
```

## Version: 1.0.5 (2024-01-09)

```
- Compiler warnings: Fixed deprecation warning for `use Bitwise`
- Compiler warnings: Fixed deprecation warning for `use Config`
- Dependencies: Updated `ex_doc` version
```

## Version: 1.0.4 (2018-08-30)

```
- Bugfix: Fix pattern match to use `48` instead of `49`
```

## Version: 1.0.3 (2018-08-08)

```
- Compiler warnings: Replace `String.to_char_list` with `String.to_charlist` to fix compiler warning
```

## Version: 1.0.2 (2017-02-03)

```
- Misc: Update `contributors` to `maintainers` in mix.exs
- Dependencies: Update `ex_doc` version used for documenation generation
- Compiler Warnings: In mix.exs to use parens in function calls to fix compiler warnings
```

## Version: 1.0.1 (2015-07-17)

```
- Code: Fix hard coded bmask to use `rem` (no behavioral change)
- Misc: Update description in mix.exs to remove unnecessary text
```

## Version: 1.0.0 (2015-07-17)

```
- Initial release 🎉
```