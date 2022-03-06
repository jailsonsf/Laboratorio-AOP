package aspectos;

import contas.Conta;
import contas.CadastroContas;
import contas.ContaNaoEncontradaException;

public aspect Precondicoes {
	pointcut pcCreditar(double valor, Conta c):
		call(void Conta.creditar(..)) && target(c) && args(valor);
	
	void around(double valor, Conta c) : pcCreditar(valor, c) {
		if (valor > 0) {
			proceed(valor, c);
			System.out.println("Creditar valor: R$ " + valor);
		}
	}
	
	
	pointcut pcDebitar(double valor, Conta c): 
		call(void Conta.debitar(..)) && target(c) && args(valor);
	
	void around(double valor, Conta c) : pcDebitar(valor, c) {
		if (valor > 0 && c.getSaldo() >= valor) {
			proceed(valor, c);
			System.out.println("Debitar valor: R$ " + valor);			
		}
	}
	
	
	pointcut pcTransferir(String numeroContaOrigem, String numeroContaDestino, double valor, CadastroContas c):
		call(void CadastroContas.transferir(..)) && target(c) && args(numeroContaOrigem, numeroContaDestino, valor);
	
	void around(String numeroContaOrigem, String numeroContaDestino, double valor, CadastroContas c):
		pcTransferir(numeroContaOrigem, numeroContaDestino, valor, c) {
		try {
			Conta contaOrigem = c.getContas().procurar(numeroContaOrigem);
			
			if (valor > 0 && contaOrigem != null && contaOrigem.getSaldo() >= valor) {
				proceed(numeroContaOrigem, numeroContaDestino, valor, c);
			}
		} catch (ContaNaoEncontradaException error) {
			error.printStackTrace();
		}
	}
}
