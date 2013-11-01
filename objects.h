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

#include <string.h>

class context
{
public:
	context()
		: bufdata(NULL), bufleng(0)
	{
		init();
	}

	~context()
	{
		delete bufdata;
		free();
	}
	
	int feed(const char* buffer, size_t size);
	
	int feed(const char* str)
	{
		return feed(str, strlen(str));
	}
	
	void parse();
	
	void parse(const char* buffer, int size);
	
	void parse(const char* str)
	{
		return parse(str, strlen(str));
	}
	
	int yyinput(char* buffer, int size);
	
	void foundint(long int num)
	{
		printf("@@@ foundint %ld\n", num);
	}
	
protected:
	void init();
	void free();

private:	
	void* scanner;
	void* ps;
	char* bufdata;
	size_t bufleng;
};