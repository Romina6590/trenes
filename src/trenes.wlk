class Deposito{
	var property formaciones
	var property locomotorasSueltas
	method necesitaCondExperimentado(){
		return formaciones.any{formacion=>formacion.esCompleja()}
	}
	method hayLocomotoraPara(formacion){
		return locomotorasSueltas.any{locomotora=>locomotora.arrastreUtil()>= formacion.cuantoParaMoverse()}
	}
	method locomotoraPara(formacion){
		return locomotorasSueltas.find{locomotora=>locomotora.arrastreUtil()>= formacion.cuantoParaMoverse()}
    }
		
	method agregarLocomotoraParaMov(formacion){
		if(not formacion.puedeMoverse() && self.hayLocomotoraPara(formacion)){
			formacion.locomotoras().add(self.locomotoraPara(formacion))
		}
	}
		
}

class Formacion{
	var property locomotoras
	var property vagones
	
	method totalPasajeros(){
		return vagones.sum{vagon=>vagon.cantidadPasajeros()}
	}
	method vagonesLivianos(){
		return vagones.count{vagon=>vagon.pesoMax() < 2500}
	}
	method velocidadMaxima(){
		return locomotoras.min{locomotora=>locomotora.velocidadMax()}.velocidadMax()
	}
	method formacionEficiente(){
		return locomotoras.all{locomotora=>locomotora.pesoMaxArrastre() >= locomotora.peso()*5}
	}
	method puedeMoverse(){
		return locomotoras.sum{locomotora=>locomotora.arrastreUtil()} >= vagones.sum{vagon=>vagon.pesoMax()}
	}
	method cuantoParaMoverse(){
		if(self.puedeMoverse()){
			return 0
		}
		else{
			return vagones.sum{vagon=>vagon.pesoMax()} - locomotoras.sum{locomotora=>locomotora.arrastreUtil()}
		}
	}
	method cantidadVagones(){
		return vagones.size()
	}
	method cantidadLocomotoras(){
		return locomotoras.size()
	}
	method vagonMasPesado(){
		return vagones.max{vagon=>vagon.pesoMax()}
	}
	method esCompleja(){
		return self.cantidadVagones() + self.cantidadLocomotoras() > 20 ||
		       locomotoras.sum{locomotora=>locomotora.peso()} + vagones.sum{vagon=>vagon.pesoMax()} > 10000
	}
}


class VagonPasajeros{
	var property largo
	var property ancho
	var property cantBanios
	method cantidadPasajeros(){
		if(ancho<=2.5){
			return largo * 8
		}
		else{
			return largo * 10
		}
	}
	method pesoMax(){
		return self.cantidadPasajeros() * 80
	}
	method baniosQueDeberiaTener(){
		return self.cantidadPasajeros() / 50
	}
	
}

class VagonCarga{
	var property cargaMax
	var property cantBanios = 0
	method cantidadPasajeros(){
		return 0
	}
	method pesoMax(){
		return cargaMax + 160
	}
	method baniosQueDeberiaTener(){
		return cantBanios
	}

}

class Locomotora{
	var property peso
	var property pesoMaxArrastre
	var property velocidadMax
	method arrastreUtil(){
		return pesoMaxArrastre - peso
	}
}

class FormacionLargaDist inherits Formacion{
	var property uneDosCiudadesGrandes
	method estaBienArmada(){
		return self.puedeMoverse() && vagones.all{vagon=>vagon.cantBanios() == vagon.baniosQueDeberiaTener()}
	}
	override method velocidadMaxima(){
		if(self.uneDosCiudadesGrandes()){
		return #{super(),200}.min()
		}
		else{
			return #{super(),150}.min()
		}	
	}
	
}


class FormacionCortaDist inherits Formacion{
	method estaBienArmada(){
		return self.puedeMoverse() && not self.esCompleja()
	}
	override method velocidadMaxima(){
		return #{super(), 60}. min()
	}
} 

class FormacionAltaVelocidad inherits FormacionLargaDist{
	override method estaBienArmada(){
		return super() && self.velocidadMaxima() < 400 && self.velocidadMaxima() > 250 && self.cantidadVagones() == self.vagonesLivianos() 
	}
}