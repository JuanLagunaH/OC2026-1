#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

#define BIT_N 0
#define BIT_O 1
#define BIT_T 2
#define BIT_G 3
#define BIT_D 4
#define BIT_U 5

void update_temp(int *temps);
void update_flags(int *temps, int *last_temps, unsigned char *flags);
void print_flag(unsigned char flag);

int main() {
    srand(time(NULL));
    unsigned char banderas[2]= {0, 0};
    int ultima[2] = {25, 25};
    int sensores[2] = {25, 25};
    int opc = 0;

    /* estado inicial */
    printf("\nSENSOR 1: %d C\n", sensores[0]);
    printf("SENSOR 2: %d C\n", sensores[1]);

    do {
        printf("\n[1] Actualizar\n[2] Salir\n\nSeleccionar opcion: ");
        scanf("%d", &opc);
        printf("\n");

        switch (opc) {
            case 1:
                update_temp(sensores);
                update_flags(sensores, ultima, banderas);
                printf("\nSENSOR 1: %d C ", ultima[0]);
                print_flag(banderas[0]);
                printf("\nSENSOR 2: %d C ", ultima[1]);
                print_flag(banderas[1]);
                printf("\n");
                break;
            case 2:
                break;
            default:
                printf("Opcion invalida.\n");
                break;
        }

    } while (opc != 2);

    return 0;
}

void update_temp(int *temps) {
    int num;
    for (int i = 0; i < 2; i++) {
        num = (rand() % 11) - 5;
        printf("Sensor %d cambio: %+d\n", i + 1, num);
        temps[i] += num;
    }
}

void update_flags(int *temps, int *last_temps, unsigned char *flags) {
    for (int i = 0; i < 2; i++) {
        int dif = temps[i] - last_temps[i];
        int absdif = abs(dif);
        flags[i]   = 0;

        if (dif > 0) set_bit(&flags[i], BIT_U);
        else if (dif < 0) set_bit(&flags[i], BIT_D);
        else set_bit(&flags[i], BIT_N);

        if (absdif == 1) set_bit(&flags[i], BIT_O);
        else if (absdif == 2) set_bit(&flags[i], BIT_T);
        else if (absdif >  2) set_bit(&flags[i], BIT_G);

        last_temps[i] = temps[i];
    }
}

void print_flag(unsigned char flag) {

    /* mostrar indicador de direccion */
    if (get_bit(flag, BIT_N)) printf("-");
    else if (get_bit(flag, BIT_U) && get_bit(flag, BIT_G)) printf(">>>");
    else if (get_bit(flag, BIT_U) && get_bit(flag, BIT_T)) printf(">>");
    else if (get_bit(flag, BIT_U)) printf(">");
    else if (get_bit(flag, BIT_D) && get_bit(flag, BIT_G)) printf("<<<");
    else if (get_bit(flag, BIT_D) && get_bit(flag, BIT_T)) printf("<<");
    else if (get_bit(flag, BIT_D)) printf("<");
}