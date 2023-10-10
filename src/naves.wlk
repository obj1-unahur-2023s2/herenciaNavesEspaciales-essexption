class Nave{
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method velocidad() = velocidad
	
	method acelerar(cuanto) {
		velocidad = 100000.min(velocidad+cuanto)
	}
	method desacelerar(cuanto) {
		velocidad = 0.max(velocidad-cuanto)
	}	
	
	method direccion() = direccion
	method irHaciaElSol() {
		direccion = 10
	}
	method escaparDelSol(){
		direccion = -10
	}
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion+1)
	}
	method alejarseUnPocoDelSol(){
		direccion = 0.max(direccion-1)
	}
	
	method combustible() = combustible
	
	method cargarCombustible(cantidad){
		combustible += cantidad
	}
	
	method descargarCombustible(cantidad){
		combustible = 0.max(combustible-cantidad)
	}
	
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}

	method estaTranquila() = combustible >= 4000 and velocidad <= 12000

	method recibirAmenaza() {
		self.avisar()
		self.escapar()
	}
	method avisar()
	method escapar()
	
	method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
	
	method tienePocaActividad()
}

class Baliza inherits Nave{
	var color
	var cambioBaliza = false
	
	method color() = color
	method cambiarColorDeBaliza(nuevoColor){
		if( color != nuevoColor) {
			color = nuevoColor
			cambioBaliza = true
		}
	}
	
	override method prepararViaje() {
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() = super() and color != "rojo"
	
	override method avisar() {
		self.irHaciaElSol()
	}
	override method escapar() {
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method tienePocaActividad() = cambioBaliza
}

class Pasajero inherits Nave {
	var pasajeros
	var comida
	var bebida
	var racionesServidas = 0
	
	method pasajeros() = pasajeros
	method comida() = comida
	method bebida() = bebida
	method cargarComida(cantidad){
		comida += cantidad
	}
	method cargarBebida(cantidad){
		bebida += cantidad
	}
	method descargarComida(cantidad){
		racionesServidas += cantidad.min(comida)
		comida = 0.max(comida-cantidad)
		
	}
	method descargarBebida(cantidad){
		bebida = 0.max(bebida-cantidad)
	}
	
	override method prepararViaje() {
		self.cargarComida(pasajeros * 4)
		self.cargarBebida(pasajeros * 6)
		super()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar() {
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
	}
	override method escapar() {
		self.acelerar(velocidad)
	}
	
	override method tienePocaActividad() = racionesServidas < 50
}

class Combate inherits Nave {
	var visible = true
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible(){
		visible = true
	}
	method ponerseInvisible(){
		visible = false
	}
	method estaInvisible() = not visible
	
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	method replegarMisiles(){
		misilesDesplegados = false
	}
	method misilesDesplegados() = misilesDesplegados

	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	method mensajesEmitidos(mensaje) = mensajes.size()
	method primerMensajeEmitido() = if (mensajes.isEmpty()){self.error("No hay mensajes emitidos")} else {mensajes.first()}
	method ultimoMensajeEmitido() = if (mensajes.isEmpty()){self.error("No hay mensajes emitidos")} else {mensajes.last()}
	method esEscueta() = mensajes.all({ m => m.size() <= 30})
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	
	override method prepararViaje(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en misión")
		super()
		self.acelerar(15000)
	}
	
	override method estaTranquila() = super() and not misilesDesplegados
	
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad() = self.esEscueta()
}

class Hospital inherits Pasajero{
	var property quirofanosPreparados = false
	
	override method estaTranquila() = super() and not quirofanosPreparados
	
	override method recibirAmenaza() {
		super()
		self.quirofanosPreparados(true)
	}
}

class CombateSigilosa inherits Combate {
	
	override method estaTranquila() = super() and visible
	
	override method recibirAmenaza() {
		self.desplegarMisiles()
		self.ponerseInvisible()
		super()
	}
}


