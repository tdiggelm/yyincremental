#include <stdio.h>
#include "objects.h"

int main()
{	
	context ctx;
	ctx.feed("123");
	ctx.feed("\n456\n");
	ctx.feed("\n78");
	ctx.feed("9\n\n\n177\n");
	ctx.parse();
	
	while(1)
	{
		context* ctx = new context();
		ctx->feed("123");
		ctx->feed("\n456\n");
		ctx->feed("\n78");
		ctx->feed("9\n\n\n177\n");
		ctx->parse();
		delete ctx;
	}
	
	return 0;
}