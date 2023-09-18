import wollok.game.*

object pou
{
	var property seRie = true
	var property edad
	var property energia
	var property energiaInicial
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

object fruta
{
	const property esSaludable = true
	const property energiaAportada = 1
}

object verdura
{
	const property esSaludable = true
	const property energiaAportada = 1
}

object bebida
{
	const property esSaludable = true
	const property energiaAportada = 0.5
}

object carne
{
	const property esSaludable = true
	const property energiaAportada = 0 //el enunciado no especifica cuanto aporta
}

object fritura
{
	const property esSaludable = false	
	const property energiaAportada = -0.2
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
		text = "Energia: " + pou.energia() + "\nEstado de Salud: " + pou.EstadoDeSalud()
	}
}