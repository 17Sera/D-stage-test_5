#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
	const char *p = s;
	while(*p != '\0'){
		p++;
	}
	return p - s;
  panic("Not implemented");
}

char *strcpy(char *dst, const char *src) {
	char *ret = dst;
	while((*dst++ = *src++) != '\0');
	return ret;
  panic("Not implemented");
}

char *strncpy(char *dst, const char *src, size_t n) {
	size_t i;
	for(i = 0; src[i] != '\0'; i++){
		dst[i] = src[i];
	}

	dst[i] = '\0';
  panic("Not implemented");
}

char *strcat(char *dst, const char *src) {
	char *ret = dst;
	while(*dst){
		dst++;
	}
	while(*src){
		*dst = *src;
		src++;
		dst++;
	}
	*dst = '\0';
	return ret;
  panic("Not implemented");
}

int strcmp(const char *s1, const char *s2) {
	int i = 0;
	while(s1[i] && s2[i] && (s1[i] == s2[i])){
		i++;
	}
	return s1[i] - s2[i];
  panic("Not implemented");
}

int strncmp(const char *s1, const char *s2, size_t n) {
	while(n--){
		if(*s1 > *s2)
			return 1;
		if(*s1 < *s2)
			return -1;
		s1++;
		s2++;
	}
	return 0;
  panic("Not implemented");
}

void *memset(void *s, int c, size_t n) {
	unsigned char *p = s;
	for(size_t i = 0; i < n; i++){
		p[i] = (unsigned char) c;
	}
	return s;
  panic("Not implemented");
}

void *memmove(void *dst, const void *src, size_t n) {
	if(dst < src){
		char *d = (char *) dst;
		char *s = (char *) src;
		while(n--){
			*d = *s;
			d++;
			s++;
		}
	}
	else{
		char *d = (char *) dst + n - 1;
		char *s = (char *) src + n - 1;
		while(n--){
			*d = *s;
			d--;
			s--;
		}
	}
	return dst;
  panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
	char *d = (char *) out;
	char *s = (char *) in;
	while(n--){
		*d = *s;
		d++;
		s++;
		//putch('a');
		//putch('\n');
	}
	return out;
  panic("Not implemented");
}

int memcmp(const void *s1, const void *s2, size_t n) {
	const unsigned char *p1 = s1;
	const unsigned char *p2 = s2;
	for(size_t i = 0; i < n; i++){
		if(p1[i] != p2[i]){
			return p1[i] - p2[i];
		}
	}
	return 0;
  panic("Not implemented");
}

#endif