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
		} else {
			System.out.println("Valor não pode ser creditado!");
		}
	}
	
	
	pointcut pcDebitar(double valor, Conta c): 
		call(void Conta.debitar(..)) && target(c) && args(valor);
	
	void around(double valor, Conta c) : pcDebitar(valor, c) {
		double saldo = c.getSaldo();
		if (saldo < valor) {
			System.out.println("Saldo insuficiente!");
		} else if (valor > 0) {
			proceed(valor, c);
			System.out.println("Debitar valor: R$ " + valor);			
		} else {
			System.out.println("Valor não pode ser debitado!");
		}
	}
	
	
	pointcut pcTransferir(String numeroContaOrigem, String numeroContaDestino, double valor, CadastroContas c):
		call(void CadastroContas.transferir(..)) && target(c) && args(numeroContaOrigem, numeroContaDestino, valor);
	
	void around(String numeroContaOrigem, String numeroContaDestino, double valor, CadastroContas c):
		pcTransferir(numeroContaOrigem, numeroContaDestino, valor, c) {
		try {
			Conta contaOrigem = c.getContas().procurar(numeroContaOrigem);
			double saldoContaOrigem = contaOrigem.getSaldo();
			
			if (valor > 0 && contaOrigem != null && saldoContaOrigem >= valor) {
				proceed(numeroContaOrigem, numeroContaDestino, valor, c);
			} else if (valor < 0) {
				System.out.println("Valor não pode ser transferido!");
			} else if (saldoContaOrigem < valor) {
				System.out.println("Saldo insuficiente!");
			}
		} catch (ContaNaoEncontradaException error) {
			error.printStackTrace();
		}
	}
}
