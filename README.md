# image_squeeze

A library for automated lossless image optimization

## Installation

The default processors depend on ImageMagick, pngcrush, gifsicle, and jpegtran.  ImageMagick is required for all processors.

## Usage

    # set up an ImageSqueeze with the default processors
    squeezer = ImageSqueeze.new(:default_processors => true)
    
    # in-place squeeze of our png
    squeezer.squeeze!('my_logo.png')

    # non-destructive squeeze
    result = squeezer.squeeze('your_logo.png')
    puts "result saved #{result.bytes_saved} bytes, new image located at #{result.output_filename}"
    
    # move tmp file to final location
    squeezer.finalize_results(result)

## TODO

* Command line runner

## Copyright

Copyright (c) 2010 Andrew Grim. See LICENSE for details.