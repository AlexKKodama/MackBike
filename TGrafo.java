//Alex Kazuo Kodama 10417942
//Thomas Pinheiro Grandin 10418118

package MackBike;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.util.StringTokenizer;

//definicao da classe de nós da lista
class TNo { // define uma struct (registro)
	public int w; // vértice que é adjacente ao elemento da lista
	public float p; // peso do aresta
	public TNo prox; // prox no

}

// definição de uma classe para armezanar um grafo
public class TGrafo {
	// atributos privados
	private int t; // tipo de grafo
	private int n; // quantidade de vértices
	private int m; // quantidade de arestas
	private TNo adj[]; // um vetor onde cada entrada guarda o inicio de uma lista
	private String rotulos[]; // armazena os rotulos dos vertices

	// métodos públicos

	// Construtor do grafo com a lista de adjacência
	public TGrafo() {
		this.n = 0;
		this.m = 0;
	}

	public TGrafo(int n) {
		this.n = n;
		this.m = 0;
		this.adj = new TNo[n];
		this.rotulos = new String[n];
	}

	// setter do rotulo
	public void setRotulo(int v, String rotulo) {
		rotulos[v] = rotulo;
	}

	// setter do tipo
	public void setType(int t) {
		this.t = t;
	}

	// Insere uma aresta não direcionada (v <-> w) com peso p
	public void insereA(int v, int w, float p) {
		inserirNaLista(v, w, p); // insere w na lista de v
		inserirNaLista(w, v, p); // insere v na lista de w
		m++; // conta apenas uma vez
	}

	// Função auxiliar para manter a lista de adjacência ordenada
	private void inserirNaLista(int origem, int destino, float peso) {
		TNo atual = adj[origem];
		TNo anterior = null;

		// percorre até encontrar posição correta (ordem crescente de destino)
		while (atual != null && destino > atual.w) {
			anterior = atual;
			atual = atual.prox;
		}

		// se já existe, não insere
		if (atual != null && atual.w == destino) {
			return;
		}

		// cria novo nó
		TNo novoNo = new TNo();
		novoNo.w = destino;
		novoNo.p = peso;
		novoNo.prox = atual;

		// atualiza ponteiros
		if (anterior == null) {
			adj[origem] = novoNo; // insere no início
		} else {
			anterior.prox = novoNo; // insere no meio ou fim
		}
	}

	// Remove uma aresta não direcionada (v <-> w)
	public void removeA(int v, int w) {
		if (v < 0 || v >= n || w < 0 || w >= n) {
			System.out.println("Vértices inválidos!");
			return;
		}

		// remove v->w
		if (removerDaLista(v, w)) {
			// remove w->v (só se a primeira remoção aconteceu)
			removerDaLista(w, v);
			m--; // conta uma aresta só uma vez
		}
	}

	// Método auxiliar: remove "destino" da lista de adjacência de "origem"
	private boolean removerDaLista(int origem, int destino) {
		TNo atual = adj[origem];
		TNo anterior = null;

		while (atual != null && atual.w != destino) {
			anterior = atual;
			atual = atual.prox;
		}

		if (atual == null) {
			return false; // não encontrado
		}

		// remove nó
		if (anterior == null) {
			// remoção no início da lista
			adj[origem] = atual.prox;
		} else {
			anterior.prox = atual.prox;
		}

		return true;
	}

	// Metodo para mostrar o grafo
	public void show() {
		System.out.print("n: " + n);
		System.out.print("\nm: " + m + "\n");
		for (int i = 0; i < n; i++) {
			System.out.print("\n" + i + ": ");
			// Percorre a lista na posição i do vetor
			TNo no = adj[i];
			while (no != null) {
				System.out.print(no.w + " ");
				no = no.prox;
			}
		}
		System.out.print("\n\nfim da impressao do grafo.\n");
	}

	// Metodo para mostrar o arquivo grafo.txt
	public void showFile(String nomeArquivo) {
		try (BufferedReader reader = new BufferedReader(new FileReader(nomeArquivo))) {
			// Tipo do grafo
			int t = Integer.parseInt(reader.readLine().trim());
			System.out.print("Tipo do grafo: ");
			graphType(t);

			// Número de vértices
			int n = Integer.parseInt(reader.readLine().trim());
			System.out.printf("Número de vértices: %d\n", n);

			// Rótulos (imprime apenas os 5 primeiros)
			int maxRotulos = Math.min(5, n);
			for (int i = 0; i < n; i++) {
				String linha = reader.readLine().trim();
				if (i < maxRotulos) {
					int aspas = linha.indexOf('"');
					String rotulo = linha.substring(aspas + 1, linha.lastIndexOf('"'));
					System.out.println(rotulo);
				}
			}

			// Número de arestas
			int m = Integer.parseInt(reader.readLine().trim());
			System.out.printf("Número de arestas: %d\n", m);

			// Arestas (imprime apenas as 5 primeiras)
			int maxArestas = Math.min(5, m);
			for (int i = 0; i < m; i++) {
				String linha = reader.readLine().trim();
				StringTokenizer st = new StringTokenizer(linha);
				int v = Integer.parseInt(st.nextToken());
				int w = Integer.parseInt(st.nextToken());
				float peso = Float.parseFloat(st.nextToken());
				if (i < maxArestas) {
					System.out.printf("%d %d %f\n", v, w, peso);
				}
			}

		} catch (IOException e) {
			System.out.println("Grafo não encontrado!");
		}
	}

	// Metodo auxiliar para printar o tipo
	private static void graphType(int t) {
		switch (t) {
			case 0:
				System.out.println("Grafo não orientado sem peso");
				break;
			case 1:
				System.out.println("Grafo não orientado com peso no vértice");
				break;
			case 2:
				System.out.println("Grafo não orientado com peso na aresta");
				break;
			case 3:
				System.out.println("Grafo não orientado com peso nos vértices e arestas");
				break;
			case 4:
				System.out.println("Grafo não orientado sem peso");
				break;
			case 5:
				System.out.println("Grafo não orientado com peso no vértice");
				break;
			case 6:
				System.out.println("Grafo não orientado com peso na aresta");
				break;
			case 7:
				System.out.println("Grafo não orientado com peso nos vértices e arestas");
				break;
			default:
				break;
		}
	}

	// Metodo que le o grafo
	public static TGrafo readGraph(String nomeArquivo) {
		try (BufferedReader reader = new BufferedReader(new FileReader(nomeArquivo))) {
			int t = Integer.parseInt(reader.readLine().trim());
			// número de vértices
			int n = Integer.parseInt(reader.readLine().trim());
			TGrafo g = new TGrafo(n);
			g.setType(t);

			// rótulos
			for (int i = 0; i < n; i++) {
				String linha = reader.readLine().trim();
				// formato: 0 "Rótulo"
				int aspas = linha.indexOf('"');
				String rotulo = linha.substring(aspas + 1, linha.lastIndexOf('"'));
				g.setRotulo(i, rotulo);
			}

			// número de arestas
			int m = Integer.parseInt(reader.readLine().trim());

			// arestas
			for (int i = 0; i < m; i++) {
				String linha = reader.readLine().trim();
				StringTokenizer st = new StringTokenizer(linha);
				int v = Integer.parseInt(st.nextToken());
				int w = Integer.parseInt(st.nextToken());
				float peso = Float.parseFloat(st.nextToken());
				g.insereA(v, w, peso);
			}

			System.out.println("Grafo lido com sucesso!");
			return g;
		} catch (IOException e) {
			System.out.println("Grafo não encontrado!");
		}
		return null;
	}

	// Metodo que salva o grafo no arquivo
	public void writeGraph(String nomeArquivo) {
		try (BufferedWriter writer = new BufferedWriter(new FileWriter(nomeArquivo))) {
			// tipo do grafo
			writer.write(String.valueOf(t));
			writer.newLine();

			// número de vértices
			writer.write(String.valueOf(n));
			writer.newLine();

			// rótulos
			for (int i = 0; i < n; i++) {
				writer.write(i + " \"" + rotulos[i] + "\"");
				writer.newLine();
			}

			// número de arestas
			writer.write(String.valueOf(m));
			writer.newLine();

			// lista de arestas (somente v < w para não repetir)
			for (int v = 0; v < n; v++) {
				TNo atual = adj[v];
				while (atual != null) {
					int w = atual.w;
					if (v < w) { // evita duplicar
						writer.write(v + " " + w + " " + atual.p);
						writer.newLine();
					}
					atual = atual.prox;
				}
			}
		} catch (IOException e) {
			System.out.println("Arquivo não encontrado");
		}
	}

	// Metodo que insere um vertice novo
	public void insereV(String rotulo) {
		// cria novos vetores com espaço para +1 vértice
		TNo[] novoAdj = new TNo[n + 1];
		String[] novosRotulos = new String[n + 1];

		// copia os antigos
		for (int i = 0; i < n; i++) {
			novoAdj[i] = adj[i];
			novosRotulos[i] = rotulos[i];
		}

		// inicializa o novo vértice
		novoAdj[n] = null; // lista de adjacência vazia
		novosRotulos[n] = rotulo; // define rótulo

		// substitui
		this.adj = novoAdj;
		this.rotulos = novosRotulos;
		this.n++;
	}

	// Remove o vértice v do grafo (não direcionado)
	public void removeV(int v) {
		if (v < 0 || v >= n) {
			System.out.println("Vértice inválido!");
			return;
		}

		// Novo vetor de adjacência e rótulos com n-1 vértices
		TNo[] novoAdj = new TNo[n - 1];
		String[] novosRotulos = new String[n - 1];

		// Reconstroi as listas e copia os rótulos
		for (int iAntigo = 0, iNovo = 0; iAntigo < n; iAntigo++) {
			if (iAntigo == v)
				continue; // pula o vértice removido

			// copia rótulo
			novosRotulos[iNovo] = rotulos[iAntigo];

			// copia lista de adjacência (ajustando índices)
			novoAdj[iNovo] = reconstruirLista(adj[iAntigo], v);

			iNovo++;
		}

		// Atualiza referências
		adj = novoAdj;
		rotulos = novosRotulos;
		n--;

		// Recalcula o número de arestas
		m = contarArestas();
	}

	// Método auxiliar: reconstrói a lista de adjacência de um vértice
	// removendo todas as arestas que apontam para 'removido'
	private TNo reconstruirLista(TNo cabeca, int removido) {
		TNo novaCabeca = null;
		TNo cauda = null;

		TNo atual = cabeca;
		while (atual != null) {
			int destino = atual.w;

			// ignora arestas que apontam para o vértice removido
			if (destino == removido) {
				atual = atual.prox;
				continue;
			}

			// ajusta índices (todos maiores que removido são decrementados)
			if (destino > removido) {
				destino--;
			}

			// cria novo nó preservando peso
			TNo novo = new TNo();
			novo.w = destino;
			novo.p = atual.p;

			// insere na nova lista
			if (novaCabeca == null) {
				novaCabeca = novo;
				cauda = novo;
			} else {
				cauda.prox = novo;
				cauda = novo;
			}

			atual = atual.prox;
		}

		return novaCabeca;
	}

	// Método auxiliar: reconta as arestas (não direcionadas)
	private int contarArestas() {
		int total = 0;
		for (int v = 0; v < n; v++) {
			TNo atual = adj[v];
			while (atual != null) {
				if (v < atual.w)
					total++; // conta só uma vez
				atual = atual.prox;
			}
		}
		return total;
	}

	// Método que mostra as informações do grafo (Grafo não direcionado)
	public void info() {
		if (isConnected()) {
			System.out.println("Grafo conexo");
		} else {
			System.out.println("Grafo não conexo");
		}
	}

	// Método auxiliar: mostra a conexidade do grafo
	private boolean isConnected() {
		if (n == 0)
			return true; // grafo vazio é considerado conexo

		boolean[] visitado = new boolean[n];

		// inicia DFS a partir do vértice 0
		dfs(0, visitado);

		// verifica se todos os vértices foram visitados
		for (boolean v : visitado) {
			if (!v)
				return false;
		}
		return true;
	}

	// Método auxiliar: DFS
	private void dfs(int u, boolean[] visitado) {
		visitado[u] = true;
		TNo atual = adj[u];
		while (atual != null) {
			if (!visitado[atual.w]) {
				dfs(atual.w, visitado);
			}
			atual = atual.prox;
		}
	}
}
