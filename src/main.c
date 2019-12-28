#include <stdio.h>
#include <SDL2/SDL.h>

const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;

int main()
{
	SDL_Window *window = NULL;
	SDL_Surface *surface = NULL;

	if( SDL_Init(SDL_INIT_VIDEO) < 0){
		printf("SDL could not initalize! SDL_error %s\n", SDL_GetError());
		return 1;
	}

	window = SDL_CreateWindow("cecs-gl", SDL_WINDOWPOS_UNDEFINED,
			 SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT,
			 SDL_WINDOW_SHOWN);

	if(window == NULL){
		printf("Window is NULL! SDL_error: %s\n", SDL_GetError());
		return 1;
	}

	surface = SDL_GetWindowSurface(window);
	SDL_FillRect(surface, NULL, SDL_MapRGB(surface->format, 0xFF, 0xFF, 0xFF));
	SDL_UpdateWindowSurface(window);

	SDL_Delay(2000);
	return 0;
}
