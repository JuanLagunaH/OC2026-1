#include <stdio.h>
#define MAX 5

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

int main() {
    int arr[MAX];
    int n;

    printf("Cuantos elementos desea ingresar? (1-5): ");
    scanf("%d", &n);

    if (n<1 || n>MAX) {
        printf("Cantidad invalida.\n");
        return 0;
    }

    printf("\nIngrese %d numeros enteros:\n", n);
    for (int i = 0; i < n; i++) {
        printf("[%d] = ", i);
        scanf("%d", &arr[i]);
    }

    printf("\nArreglo: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);

    printf("\n\nMaximo: %d\n", maximo   (arr, n));
    printf("Minimo: %d\n", minimo   (arr, n));
    printf("Sumatoria: %d\n", sumatoria(arr, n));

    return 0;
}
