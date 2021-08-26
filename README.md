# ffmpeg-Batch-Converter

Create these directories:

`ROOT` -> where `Batch_Converter.bat` goes

+-- `_inout` -> put your images, videos etc. in here.

+-- `bin` -> in here go the ffmpeg binaries (https://www.ffmpeg.org/download.html).


Start the batch `Batch_Converter.bat`.


    ***********************************************************
    *               FFMPEG simple converter                   *
    ***********************************************************
    *   Press number or letter in [] to select your task      *
    *       WARNING: Orginal files will be REPLACED           *
    ***********************************************************

     [1]  Convert to AVI

     [3]  Movie to Frames (filename.mp4 to filename_0000.png)
     [4]  Frames to Movie (filename_0000.png to filename.mp4)
     [5]  Convert to h264 (MP4) (set quality [q] first)
     [6]  Convert to h264 (MP4) in two passes (set quality [q] first)

     [7]  MTS Deinterlace (loosless; yadif; mcdeint;
           = very long process but best.)
     [8]  MP4 Deinterlace (loosless; yadif;  OK.)
     [9]  MP4 Deinterlace (-deinterlace;     Not Recommended.)

     [a]  Deinterlace to frames (filename.mp4 to filename_0000.png)
     [b]  Convert to MP3
     [c]  Remove Art (image) from MP3

     [g]  Convert to GIF ... yes, gif.
     [h]  Frames to GIF (direct conversion; set framerate [r])


     [v]  ffmpeg version
     [x]  EXIT
    ---------------------------------------------------------
     Found 0 file(s) in directory D:\ffmpeg\_inout

     Options:
      [e] Set output height                      : default
      [f] Set number of digits 'movie to frames' : 4
      [q] Set compression quality                : -b:v 20000K
      [r] Set framerate                          : 24
      [s] Set MP3 quality                        : -b:a 192k
          Video Audio                            : -b:a 192k

    READY:

