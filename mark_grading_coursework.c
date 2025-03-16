


/*registration number: 200344795*/

#include <stdio.h>
#define module 5
#define credits 5
#define maximum_possible_credits 60
#define name 7
#define YES 1
#define NO 2

int module_marks[module];
int module_i;
int credits_value [credits] = {10,10,10,10,20}; 
const char *module_name[name]={" Maths 1 " ," Maths 2 " ," Tech. 1 " ," Tech. 2 " ," Coursework " ," Credits Awarded " ," Overall Average Mark"};
const int credits_name [credits] = {10,10,10,10,20}; 

/*this CREDITS() function is used to calculate 
the overall average mark by using the formula given.
the credits are summed up first before going through 
the formula. the return value "x" is the overall average mark
*/
float CREDITS(){
float x, y;
int credit_i=0;

	for (module_i=0; module_i<module; module_i++)
	{
	y+=(module_marks[module_i]*credits_value[module_i]);
	}
	x=y/maximum_possible_credits;
	

return (x);	
}

/*the function MODULES() is used to require the marks for all
modules and stored in an array module_marks[module]
*/
int MODULES()
{
	int module_i = 0; 
	 do {
      printf("\nEnter mark for %s : ",module_name[module_i]);
      scanf(" %d",&module_marks[module_i]);

	  while (module_marks[module_i]<=0||module_marks[module_i]>=100)
	  {
	  		printf("\nThe value is out of range of 0-100\n");
	  		printf("Please enter a new mark: ");
      	scanf(" %d",&module_marks[module_i]);
		}
      ++module_i;
    }
    
    while (module_i<module);

}

/*PASS_FAIL_CREDITS is a function to know that the student will be awarded with 
credit or not based on the marks for each module. Besides, this function also 
allow the user to know that if the mark for coursework is less than equal to 40,
the student will automatically fail the year
*/
int PASS_FAIL_CREDITS()
{
	int z;
	int y;
if (module_marks[4]<=40){
credits_value[4]=0;
printf("\nThe student will not awarded credits for Coursework");
printf("\nThe student did not PASS the whole year");
}
for (module_i=0; module_i<module-1; module_i++)
{
	if (module_marks[module_i]<=40)
	credits_value[module_i]=0;
	z+=credits_value[module_i];
}
	z+=credits_value[4];
	
	return (z-5);
}

int highest_mark()
{
	int a=0,c;
	int highest=a;
	
		for (c=0;c<module;c++)
		{
		if (module_marks[c]>a)
		a=module_marks[c];
		}
		printf("%d", a);
		return (a);
}

/*The highest_mark and lowest_mark function are used to determine the
highest and lowest mark of the student when being requested by the user*/

int lowest_mark()
{
	int b,d;
	int highest=b;
		for (d=0;d<module;d++)
		{
		if (module_marks[d]<b)
		b=module_marks[d];
		}
		printf("%d", b);
		return (b);
}
int main (void)

{
int x,q;
int credit_i;
int my_choice;
int repeat_students;
	float Overall_average_marks;
	int total_credits_awarded,highest,lowest;
	do
{
	printf("------------------------------------------------------------------------------------------------------------------");
	printf("\n------------------------------------------------------------------------------------------------------------------");
	printf("\n\t\t\tTO DETERMINE THAT THE STUDENT PASS OR FAIL FOR THE YEAR");
	printf("\n------------------------------------------------------------------------------------------------------------------");
	printf("\n------------------------------------------------------------------------------------------------------------------");
	printf("\n");
	MODULES();
	total_credits_awarded=PASS_FAIL_CREDITS();
	Overall_average_marks=CREDITS();
	highest=highest_mark();
	lowest=lowest_mark();
	printf("\n\n");
	printf("\n------------------------------------------------------------------------------------------------------------------");
	printf("\n\t\t\t");
	for (module_i=0;module_i<name;module_i++)
	{
		printf("%s", module_name[module_i]);
	}
	printf("\n------------------------------------------------------------------------------------------------------------------");
		printf("\nMarks awarded");
	printf("\t\t");
	for (x=0;x<module;x++)
	{
		printf(" %7d", module_marks[x]);
	}
	printf("\t\t\t    %.1f", Overall_average_marks);
		printf("\nPossible credits");
	printf("\t");
	for (credit_i=0;credit_i<credits;credit_i++)
{ printf(" %7d", credits_name[credit_i]);
}
	
	printf("\nCredit awarded");
	printf("\t\t");
		for (q=0;q<credits;q++)
{ printf(" %7d", credits_value[q]);
}
	printf("\t");
	printf(" %7d", total_credits_awarded);
	printf("\n------------------------------------------------------------------------------------------------------------------");
	printf("\n");
	if (total_credits_awarded>=40&&Overall_average_marks>=39.5)
	printf("\nThe student PASS the Academic Year");
	else 
	printf("\nThe student FAIL the Academic Year");
	printf("\n");
	printf("\nDo you want to know the HIGHEST and the LOWEST marks of the student?");
	printf("\nIf YES, press: 1   if NO, press: 2\n");
	scanf("%d",&my_choice);
	
	switch (my_choice)
	{
		case YES:
			printf("\nThe HIGHEST mark is %d", highest);
			printf("\nThe LOWEST mark is %d", lowest);
			printf("\n");
			printf("\nDo you wish to repeat for other student?");
			printf("\nIf Yes, press: 1   if No, press: 2\n");
			break;
		
		case NO:
			printf("\nDo you wish to repeat for other student?");
			printf("\nIf Yes, press: 1   if No, press: 2\n");
			break;
	}
	scanf("%d",&repeat_students);
}
	while (repeat_students==1);
	
	return(0);
}



