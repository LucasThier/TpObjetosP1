import wollok.game.*
class CompanieroDeJuegoCansado inherits wollok.lang.Exception {}

class Mascota 
{
	var property seRie = true
	var property edad = 0
	var property energia = 0
	var property energiaInicial = 0
	var property cantAlimentosSaludables = 0
	var property cantAlimentosInsalubres = 0
	var property comio = false;
	var property jugo = false;
	
	var property image = "pou limpio sonrriendo.png"
	var property position = game.at(2,3)
	
	//es necesario inicializar "edad" antes de llamar a este metodo
	method IniciarJuego()
	{
		game.width(5)
		game.height(7)
		game.cellSize(100)
		game.title("El mejor Pou de la historia")
		game.onTick(500, "actualizar", { self.ActualizarEstadoPou() })
		game.start()
		game.addVisual(self)
		game.addVisual(pelota)
		game.addVisual(duchador)
		game.addVisual(energizante)
		game.addVisual(lampara)
		game.addVisual(comestibles)
		game.addVisual(estadisticas)
		keyboard.num1().onPressDo { self.Banarse() }
		keyboard.num2().onPressDo { self.Jugar(pelota) }
		keyboard.num3().onPressDo { self.Dormir() }
		keyboard.num4().onPressDo { self.Energizar() }
		keyboard.q().onPressDo { self.Comer(fruta) }
		keyboard.w().onPressDo { self.Comer(verdura) }
		keyboard.e().onPressDo { self.Comer(bebida) }
		keyboard.r().onPressDo { self.Comer(fritura) }
		keyboard.t().onPressDo { self.Comer(carne) }	
	}
	
	method ActualizarEstadoPou()
	{
		estadisticas.SetearEstadisticas(self)
	
		//esta limpio y no se rie
		if(!self.EstaSucio() && !seRie)
		{
			image = "pou limpio sin sonrreir.png"
		}
		//esta limpio y se rie
		else if(!self.EstaSucio() && seRie)
		{
			image = "pou limpio sonrriendo.png"
		}
		//esta sucio y no se rie
		else if(self.EstaSucio() && !seRie)
		{
			image = "pou sucio sin sonrreir.png"
		}
		//esta sucio y se rie
		else
		{
			image = "pou sucio sonrriendo.png"
		}
	}
	
	method estaAburrido()
	{
		return self.EstadoDeSalud() == "Aburrido"
	}
	
	//setter
	method edad(edadAsignada)
	{
		edad = edadAsignada;
		energia = edadAsignada * 10
		energiaInicial = energia
	}
    
    method EstaSucio()
    {
    	return comio && jugo
    }
    
    method EstadoDeSalud()
    {
    	var alimetacionSaludable
    	if(cantAlimentosInsalubres + cantAlimentosSaludables != 0)
    		alimetacionSaludable = 1 >= (cantAlimentosInsalubres / (cantAlimentosInsalubres + cantAlimentosSaludables))
    	else alimetacionSaludable = true
    	
    	if(cantAlimentosInsalubres > cantAlimentosSaludables)
    	{
    		return "Deplorable"
    	}
    	else if(cantAlimentosInsalubres == cantAlimentosSaludables)
    	{
    		return "Alarmante"
    	}
    	else if(alimetacionSaludable && seRie)
    	{
    		return "Normal";
    	}
    	else if(alimetacionSaludable)
    	{
    		return "Aburrido";
    	}
    	return "Desconocido"
    }
    
    method Comer(comida)
    {
    	if(energia < energiaInicial)
    	{
    		seRie = true
    	}
    	energia += comida.energiaAportada()
    	if(comida.esSaludable()) cantAlimentosSaludables++
    	else cantAlimentosInsalubres++;
    	
    	comio = true
    }
    
    method Banarse()
    {
    	comio = false
    	jugo = false
    	energia -= 2
    	seRie = false
    }
    
    method JugarConOtro(amigo)
    {
    	if(amigo.estaAburrido() == self.estaAburrido() && !self.hayDiferenciaDeEnergias(amigo))
    	{
    		amigo.JugarConOtro()
			self.JugarConOtro()
    	}
    	else
    	{
			throw new CompanieroDeJuegoCansado()
    	}
    }
    
    //no aclara mucho el enunciado asi que suponemos que tiene el mismo efecto que jugar con la pelota.
    method JugarConOtro()
    {
    	energia--
    	//si juega y no esta cansado, se rie, si no no se rie
    	seRie = energia >= energiaInicial
    	jugo = true
    }
    
    method hayDiferenciaDeEnergias(amigo)
    {
    	return (self.estaAburrido() && self.energia() >= amigo.energia()) || (amigo.estaAburrido() && amigo.energia() >= self.energia())
    }
    
    method Jugar(juego)
    {
    	energia--    	
    	//si juega y no esta cansado, se rie, si no no se rie
    	seRie = energia >= energiaInicial
    	jugo = true
    }
    
    method Energizar()
    {
    	if(energia < energiaInicial)
    		energia = energiaInicial
    }
    
    method Dormir()
    {
    	energia += 0.1 * energiaInicial
    }
}

object pelota
{
	var property position = game.at(1,0) 
	var property image = "pelota.png"
	}

object duchador
{
	var property position = game.at(0,0) 
	var property image = "duchador.png"
}

object energizante
{
	var property position = game.at(3,0) 
	var property image = "energizante.png"
}

object lampara
{
	var property position = game.at(2,0) 
	var property image = "lampara.png"
}

object comestibles
{
	var property position = game.at(4,0) 
	var property image = "comestibles.png"
}

object estadisticas
{
	var property text = ""
	var property position = game.at(1,6)
	method SetearEstadisticas(pou)
	{	
		text = "Energia: " + pou.energia() + "\nEstado de Salud: " + pou.EstadoDeSalud() + "\nEdad: " + pou.edad()
	}
}

object pouAdulto inherits Mascota
{
	var contadorAccionesRealizadas = 0
	const cantAccionesParaCrecerUnAnio = 5
	
	
	override method edad()
	{
		return edad + (contadorAccionesRealizadas / cantAccionesParaCrecerUnAnio) - ((contadorAccionesRealizadas / cantAccionesParaCrecerUnAnio) % 1)
	}
	
	override method Comer(comida)
    {
		contadorAccionesRealizadas++
		super(comida)
	}
	
	override method Banarse()
    {
    	contadorAccionesRealizadas++
    	super()
    }
    
    override method Jugar(juego)
    {
    	contadorAccionesRealizadas++
    	super(juego)
    }
    
    override method Energizar()
    {
    	contadorAccionesRealizadas++
    	super()
    }
    
    override method Dormir()
    {
    	contadorAccionesRealizadas++
    	super()
    }
}

object sarten
{
	const property seUsaParaFreir = false
}

object freidora
{
	const property seUsaParaFreir = true
}

object plancha
{
	const property seUsaParaFreir = false
}

object olla
{
	const property seUsaParaFreir = false
}

class Alimento
{
	const property coccion
	
	method esSaludable()
	{
		return !coccion.seUsaParaFreir()
	}
	
	method energiaAportada()
	{
		if(coccion.seUsaParaFreir())
		{
			return -0.2
		}
		
		return 0.2
	}
}

object fruta inherits Alimento(coccion = null)
{
	override method esSaludable()
	{
		return true
	}

	override method energiaAportada()
	{
		return 1
	}
}

object verdura inherits Alimento(coccion = null)
{
	override method esSaludable()
	{
		return true
	}

	override method energiaAportada()
	{
		return 1
	}
}

object bebida inherits Alimento(coccion = null)
{
	override method esSaludable()
	{
		return true
	}

	override method energiaAportada()
	{
		return 0.5
	}
}

object carne inherits Alimento(coccion = plancha) {}

object fritura inherits Alimento(coccion = freidora) {}