//Alex Kazuo Kodama 10417942
//Thomas Pinheiro Grandin 10418118

package MackBike;

import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		int opt, v, w, s;
		float p;
		TGrafo grafo = null;

		do {
			System.out.println("MackBike - Navegação para Ciclovias");
			System.out.println("1) Ler dados do arquivo");
			System.out.println("2) Gravar dados no arquivo");
			System.out.println("3) Inserir vértice");
			System.out.println("4) Inserir aresta");
			System.out.println("5) Remover vértice");
			System.out.println("6) Remover aresta");
			System.out.println("7) Mostrar conteúdo do arquivo");
			System.out.println("8) Mostrar grafo");
			System.out.println("9) Informações do grafo");
			System.out.println("10) Djikstra");
			System.out.println("11) Bellman-Ford");
			System.out.println("12) SPFA");
			System.out.println("0) Encerrar aplicação");

			while (!scanner.hasNextInt()) {
				System.out.println("Opção inválida. Selecione um número de 1 a 0");
				scanner.hasNext();
			}
			opt = scanner.nextInt();
			scanner.nextLine();

			switch (opt) {
				case 1:
					grafo = TGrafo.readGraph("grafo.txt");
					wait(scanner);
					break;
				case 2:
					grafo.writeGraph("grafo.txt");
					System.out.println("Grafo gravado com sucesso!");
					wait(scanner);
					break;
				case 3:
					System.out.printf("Digite o nome do vértice:");
					String rotulo = scanner.nextLine();
					grafo.insereV(rotulo);
					System.out.printf("\n\nVértice %s inserido!\n", rotulo);
					wait(scanner);
					break;
				case 4:
					System.out.printf("Digite os vértices a serem inserido a aresta:");
					v = scanner.nextInt();
					w = scanner.nextInt();
					System.out.printf("\nDigite o peso da aresta:");
					p = scanner.nextFloat();
					grafo.insereA(v, w, p);
					System.out.println("Aresta inserida!");
					wait(scanner);
					break;
				case 5:
					System.out.printf("Digite o vértice a ser removido:");
					v = scanner.nextInt();
					grafo.removeV(v);
					System.out.println("Vértice removido!");
					wait(scanner);
					break;
				case 6:
					System.out.printf("Digite os vértices da aresta a ser removida:");
					v = scanner.nextInt();
					w = scanner.nextInt();
					grafo.removeA(v, w);
					System.out.println("Aresta removida!");
					wait(scanner);
					break;
				case 7:
					grafo.showFile("grafo.txt");
					wait(scanner);
					break;
				case 8:
					grafo.show();
					wait(scanner);
					break;
				case 9:
					grafo.info();
					wait(scanner);
					break;
				case 10:
					System.out.println("Qual o vértice de inicio?");
					s = scanner.nextInt();
					grafo.dijkstra(s);
					wait(scanner);
					break;
				case 11:
					System.out.println("Qual o vértice de inicio?");
					s = scanner.nextInt();
					grafo.bellmanFord(s);
					wait(scanner);
					break;
				case 12:
					System.out.println("Qual o vértice de inicio?");
					s = scanner.nextInt();
					grafo.spfa(s);
					wait(scanner);
					break;
				case 0:
					System.out.println("Encerrando aplicação...");
					break;
				default:
					System.out.println("Opção inválida. Selecione um número de 1 a 0");
			}
		} while (opt != 0);
		scanner.close();
	}

	//Função auxiliar para esperar o input
	static void wait(Scanner scanner) {
		System.out.println("Pressione Enter para voltar para o menu...");
		scanner.nextLine();
	}
}
