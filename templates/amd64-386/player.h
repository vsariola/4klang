// auto-generated by Sointu, editing not recommended
#ifndef SU_RENDER_H
#define SU_RENDER_H

#define SU_MAX_SAMPLES     {{.MaxSamples}}
#define SU_BUFFER_LENGTH   (SU_MAX_SAMPLES*2)

#define SU_SAMPLE_RATE     44100
#define SU_BPM             {{.Song.BPM}}
#define SU_ROWS_PER_BEAT  {{.Song.RowsPerBeat}}
#define SU_PATTERN_SIZE    {{.Song.Score.RowsPerPattern}}
#define SU_MAX_PATTERNS    {{.Song.Score.Length}}
#define SU_TOTAL_ROWS      (SU_MAX_PATTERNS*SU_PATTERN_SIZE)
#define SU_SAMPLES_PER_ROW (SU_SAMPLE_RATE*60/(SU_BPM*SU_ROWS_PER_BEAT))

#include <stdint.h>
#if UINTPTR_MAX == 0xffffffff
    #if defined(__clang__) || defined(__GNUC__)
        #define SU_CALLCONV __attribute__ ((stdcall))
    #elif defined(_WIN32)
        #define SU_CALLCONV __stdcall
    #endif
#else
    #define SU_CALLCONV
#endif

{{- if .Output16Bit}}
typedef short SUsample;
#define SU_SAMPLE_RANGE 32767.0
{{- else}}
typedef float SUsample;
#define SU_SAMPLE_RANGE 1.0
{{- end}}


#ifdef __cplusplus
extern "C" {
#endif

void SU_CALLCONV su_render_song(SUsample *buffer);
{{- if gt (.SampleOffsets | len) 0}}
void SU_CALLCONV su_load_gmdls();
#define SU_LOAD_GMDLS
{{- end}}


#ifdef __cplusplus
}
#endif

#endif