/* Copyright (c) 2013 Thomas Diggelmann. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#include <stdio.h>
#include "objects.h"

int main()
{	
	// TODO: add possibility to create context on traditional input file
	// TODO: build virtual class that is extendable for integration with other parsers
	// TODO: add namespace
	// TODO: add optional buffer limit
	// TODO: add clear buffer function
	
	context ctx;
	ctx.feed("123");
	ctx.feed("\n456\n");
	ctx.parse();
	ctx.feed("\n78");
	ctx.feed("9\n\n\n177\n55");
	ctx.parse();
	ctx.feed("\n");
	ctx.parse();
	
	while(0)
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