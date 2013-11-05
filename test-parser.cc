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

#include <iostream>
#include <signal.h>
#include <memory>
#include "parser.h"

using namespace std;

class intparser : public parser
{
public:
	void foundint(long int num)
	{
		cout << "@@@ integer: " << num << endl;
	}
	void error(const char* msg)
	{
		cout << "@@@ error: " << msg << endl;
	}
	void quit()
	{
		cout << "@@@ quit" << endl;
	}
};

int main(int argc, char** argv)
{
	char buf[2000];
	memset(buf, 1, 2000);
	int i = 100;
	while(i--) {
		intparser pp;
		pp.feed(buf, 1000);
		pp.parse();
		pp.feed(buf, 1000);
		pp.feed(buf, 1000);
		pp.parse();
		pp.feed(buf, 1000);
		pp.feed(buf, 1000);
		pp.parse();
	}
	
	i = 100;
	while(i--) {
		intparser* pp = new intparser();
		pp->feed(buf, 1000);
		pp->parse();
		pp->feed(buf, 1000);
		pp->feed(buf, 1000);
		pp->parse();
		pp->feed(buf, 1000);
		pp->feed(buf, 1000);
		pp->parse();
		delete pp;
	}

	i = 100;
	while(i--) {
		std::auto_ptr<intparser> pp(new intparser());
		pp->feed(buf, 1000);
		pp->parse();
		pp->feed(buf, 1000);
		pp->feed(buf, 1000);
		pp->parse();
		pp->feed(buf, 1000);
		pp->feed(buf, 1000);
		pp->parse();
		//delete pp;
	}
	
	intparser pp;
	pp.feed("123");
	pp.feed("\n456\n");
	pp.parse();
	pp.feed("\n78");
	pp.feed("9\n\n\n177\n55");
	pp.parse();
	pp.feed("\n");
	pp.parse();
	
	while(0)
	{
		intparser* pp = new intparser();
		pp->feed("123");
		pp->feed("\n456\n");
		pp->feed("\n78");
		pp->feed("9\n\n\n177\n");
		pp->parse();
		delete pp;
	}
	
	return 0;
}