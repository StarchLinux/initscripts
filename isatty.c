#include <unistd.h>

int main(int argc, char** argv)
{
	return !isatty(1);
}
