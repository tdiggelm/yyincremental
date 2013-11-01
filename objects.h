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