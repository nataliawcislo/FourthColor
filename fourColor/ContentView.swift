//
//  ContentView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 08/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//
import SwiftUI

struct ContentView: View {
	
	@State var showMenu = false
	
	var body: some View {
		GeometryReader { page in
			NavigationView{
				ZStack(alignment: .leading){
					HomeView().frame(width: page.size.width, height: page.size.height)
						.offset(x: self.showMenu ? page.size.width / 1.5 : 0)
						//gesty
						.navigationBarTitle("Defect title")
						.navigationBarItems(leading: Button(action: {
							withAnimation{self.showMenu.toggle()}}) {
								Image(systemName: "sidebar.left")
									.imageScale(.large)
									.foregroundColor(.black)
									.frame(width: 40, height: 40)
						})
					if self.showMenu {
						MenuView().frame(width: page.size.width / 1.5)
							.transition(.move(edge: .leading))
					}
				}
				.navigationBarTitle("Defect title", displayMode: .inline)
				.navigationBarItems(leading: Button(action: {
					withAnimation{self.showMenu.toggle()}}) {
						Image(systemName: "sidebar.left")
							.imageScale(.large)
							.foregroundColor(.black)
							.frame(width: 40, height: 40)
				})
			}
		}
	}
}






struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}



