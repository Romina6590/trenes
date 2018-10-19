import trenes.*
object empresaFerroviaria {
	var property depositos
	method conjuntoPesados(deposito){
		return deposito.formaciones().map{formacion=>formacion.vagonMasPesado()}.asSet()
	}
	
}
