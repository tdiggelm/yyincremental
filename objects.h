
class context
{
public:
	context(int fd)
		: fd(fd)
	{
		init();
	}

	~context()
	{
		free();
	}
	
	void parse();
	int yyinput(char* buffer, int size);
	
protected:
	void init();
	void free();

private:	
	void* scanner;
	int fd;
	void* ps;
};