package aspectos;

import contas.Conta;

public aspect Mensagens {
	before(Conta c, double valor) : pcCreditar(c, valor) {
		System.out.println("Saldo atual �: " + c.getSaldo());
	}
	
	before(Conta c, double valor) : pcCreditar(c, valor) {
		System.out.println("Vou creditar " + valor);
	}
	
	after(Conta c, double valor) : pcCreditar(c, valor) {
		System.out.println("Saldo atualizado �: " + c.getSaldo());
	}
	
	pointcut pcCreditar(Conta c, double valor): target(c) && args(valor) && call(public * creditar(..));
}
