#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>
#include <stdbool.h>

void help() {
    printf("help\r\n");
    exit(1);
}
 
int main(int argc,char **argv)
{
	DIR *dirp;
    char path[1024];
	struct dirent *direntp;
    FILE *f_dst;
    FILE *f_tmp;
    char output_name[1024];
    char line[1024];
    int line_num;
    bool is_first_file = true;
    int i;
 
    if(argc == 0) {
        help();
    }

    for(i=1;i<argc;i++){
        if(!strcmp(argv[i], "-d")) {
            i++;
            if(i > argc) {
                help();
            }
            strcpy(path, argv[i]);
        }
        if(!strcmp(argv[i], "-o")) {
            i++;
            if(i > argc) {
                help();
            }
            strcpy(output_name, argv[i]);    
        }
    }
 
	/* 打开目录 */	
	if((dirp=opendir(path))==NULL)
	{
		printf("Open Directory %s Error: %s\r\n", path, strerror(errno));
		exit(1);
	}

    f_dst = fopen(output_name, "w+");
 
	/* 返回目录中文件大小和修改时间 */
	while((direntp=readdir(dirp))!=NULL) 
	{
		/* 给文件或目录名添加路径:argv[1]+"/"+direntp->d_name */
		char filename[512]; 
		memset(filename,0,sizeof(filename)); 
		strcpy(filename,path);
        #ifdef WIN
		    strcat(filename,"\\"); 
        #else 
            strcat(filename, "/");
        #endif
		strcat(filename,direntp->d_name);
        if(memcmp(filename + strlen(filename) - 4, ".csv", 4) != 0)
            continue;

        printf("%s\r\n", filename);

        if((f_tmp = fopen(filename, "r")) == NULL){
            exit(1);
        }

        line_num = 0;
        while(fgets(line, sizeof(line), f_tmp)){
            if(line_num == 0){       
                if(is_first_file == true) 
                    is_first_file = false;
                else {
                    line_num ++;
                    continue;
                }
            }
            fwrite(line, sizeof(char), strlen(line), f_dst);
            line_num++;
        }

        if(fclose(f_tmp) != 0){
            exit(1);
        }
	}

    if(fclose(f_dst) != 0){
        exit(1);
    }
 
	closedir(dirp);
	exit(1);
}
