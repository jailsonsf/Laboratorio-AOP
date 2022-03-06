package contas;

public class ContaNaoEncontradaException extends Exception {
	private static final long serialVersionUID = 1L;

	private String numero;

	public ContaNaoEncontradaException(String numero) {
		super("Conta não encontrada!");
		this.numero = numero;
	}

	public String getNumero() {
		return numero;
	}
}
