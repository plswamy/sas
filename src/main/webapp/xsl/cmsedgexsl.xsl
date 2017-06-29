<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0"> 
<xsl:template match="root">
 <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<fo:layout-master-set>
	    <fo:simple-page-master 
	             master-name="all" 
	             page-height="23in" 
	             page-width="18.5in" 
	             margin-top="0.5in" 
	             margin-bottom="0.5in" 
		         margin-left="0.6in" 
		         margin-right="0.6in">
			<fo:region-body 
			    margin-top="3.9in" 
			    margin-bottom="4.0in"/>
			   <fo:region-before extent="10.2in" />
			   <fo:region-after extent="1.2in"/>
	    </fo:simple-page-master>
	</fo:layout-master-set> 
      <!-- Header start   -->   
	<fo:page-sequence master-reference="all" >
      <fo:static-content flow-name="xsl-region-before">
	    <fo:block >
		  <fo:table  width="100%">
		     <fo:table-column column-width="80%"/>
			   <fo:table-body>
			      <fo:table-row>
				      <fo:table-cell >
				         <fo:block start-indent = "37cm">
							<fo:external-graphic display-align="right">
								<xsl:attribute name="src">
									<xsl:text>'</xsl:text>
									<xsl:value-of select="data/main/imgPath"/><xsl:text>/</xsl:text>
									<xsl:value-of select="data/main/Company_Logo"/><xsl:text>'</xsl:text>
								</xsl:attribute>
							</fo:external-graphic>
				         </fo:block>
	      			   </fo:table-cell>
				    </fo:table-row>
				</fo:table-body>
			</fo:table>
	   </fo:block>
           

           <fo:block >
			 <fo:table >
				<fo:table-column column-width="0cm"/>
				<fo:table-column column-width="0cm"/>
				<fo:table-column column-width="0cm"/> 
				<fo:table-column column-width="0cm"/>
                	<fo:table-body>
					  	<fo:table-row>
				      		<fo:table-cell>
				       	 		<fo:block font-family="arial" font-size="9pt" >
                                  </fo:block>
				      		</fo:table-cell>	
						 <fo:table-cell text-align="margin-right" >
				        	<fo:block start-indent="1.2cm"  font-family="arial" font-weight="bold" color="blue" font-size="47pt" wrap-option="no-wrap" >
				          			Travel Risk Management self-assessment
				        	</fo:block>
				      	 </fo:table-cell>	
				       </fo:table-row>	
                    </fo:table-body>
			  </fo:table>
		    </fo:block>

				

			<fo:block text-align="start" line-height="1em + 2pt">
				 <fo:table >
				    	<fo:table-column column-width="0cm"/>
						<fo:table-column column-width="0cm"/>
						<fo:table-column column-width="0cm"/> 
						<fo:table-column column-width="0cm"/>
							<fo:table-body>
				    			<fo:table-row>
				      				<fo:table-cell>
										<fo:block font-family="arial" font-size="9pt" >
				                        </fo:block>
				      				</fo:table-cell>
				       
				     				  <fo:table-cell  text-align="margin-left">
				      					<fo:block start-indent="1.2cm"  font-family="arial" color="black" font-size="40pt" wrap-option="no-wrap" >
				         				 Your Summary - <xsl:value-of select="data/main/user"/><xsl:text></xsl:text>
				                        </fo:block>
				        			  </fo:table-cell>
                           		</fo:table-row>
                      		</fo:table-body>
                 </fo:table>
             </fo:block>


			<fo:block text-align="start" line-height="1em + 2pt">
				<fo:table  table-layout="fixed" width="300%" space-before="0.6cm" border-top-style="solid" border-top-width="2pt" padding="9mm">
						<fo:table-column column-width="28cm"/>
						<fo:table-column column-width="28cm"/>
						<fo:table-column column-width="28cm"/> 
						<fo:table-column column-width="28cm"/>
                			 <fo:table-body>
					 			 <fo:table-row>
				      				<fo:table-cell>
				        				<fo:block font-family="arial" font-size="7pt" >
				      					</fo:block>
				        			</fo:table-cell>	

				      				<fo:table-cell text-align="margin-right" >
				        				<fo:block  start-indent = "-10.5cm" font-family="arial" font-weight="bold" color="blue" font-size="40pt" wrap-option="no-wrap" padding="0.8mm">
				  						You scored <xsl:value-of select="data/main/score"/><xsl:text></xsl:text>
				        				</fo:block>
				      				</fo:table-cell>	
				       			 </fo:table-row>	

				      		 </fo:table-body>
				 </fo:table>
			</fo:block> 
			</fo:static-content>   
 <!-- Header end -->
 <!-- footer start   -->  
            <fo:static-content flow-name="xsl-region-after">        
		           <fo:block text-align="start" line-height="2em + 2pt" wrap-option="no-wrap">
   			            <fo:table table-layout="fixed" start-indent="-4.4cm" >
				           <fo:table-column column-width="50cm"/>
					          <fo:table-body>
						          <fo:table-row>
				                      <fo:table-cell text-align="center">
				                            <fo:block  color="navy" font-family="arial" font-size="40pt" font-weight="bold"> WORLDWIDE REACH. 
				                       <fo:inline color="blue">HUMAN TOUCH.</fo:inline> </fo:block>
				                       </fo:table-cell>				      
				                   </fo:table-row>
		      		           </fo:table-body>
		                </fo:table>
		            </fo:block>
	        </fo:static-content> 
<!-- Footer end -->  
<!--Body starts-->   
	
     <fo:flow flow-name="xsl-region-body">
		<xsl:apply-templates select="data"/>
            <fo:block text-align="start" line-height="1em + 2pt">
				<fo:table  table-layout="fixed" space-before="0.8cm" width="300%" height="4cm" border-top-style="solid" border-top-width="2pt" border-bottom-style="solid" border-bottom-width="2pt"  padding="9mm" >
					<fo:table-column column-width="43cm"/>
					<fo:table-column column-width="43cm"/>
					<fo:table-column column-width="43cm"/> 
					<fo:table-column column-width="43cm"/>
						<fo:table-body>
				  			<fo:table-row>
				     			 <fo:table-cell >
				         			<fo:block start-indent="0cm" >
										<fo:external-graphic padding-right="1cm">
											<xsl:attribute name="src">
												<xsl:text>'</xsl:text><xsl:value-of select="data/main/imgPath"/><xsl:text>/</xsl:text>
												<xsl:value-of select="data/main/range"/><xsl:text>'</xsl:text>
											</xsl:attribute>
											<xsl:attribute name="height">70cm</xsl:attribute>
											<xsl:attribute name="width">300cm</xsl:attribute>
											<xsl:attribute name="align">right</xsl:attribute>
										</fo:external-graphic>
				         			</fo:block>
	      			   			 </fo:table-cell>
	      			    	

						</fo:table-row>
					   </fo:table-body>
				</fo:table>
			</fo:block>

		
		    <fo:block text-align="start" line-height="1em + 2pt">
			  <fo:table  table-layout="fixed" padding="9mm" >
				<fo:table-column column-width="0cm"/>
				<fo:table-column column-width="26cm"/>
				<fo:table-column column-width="26cm"/> 
				<fo:table-column column-width="29cm"/>
						<fo:table-body>
				  			<fo:table-row>
								<fo:table-cell>
                                   <fo:block font-family="arial" font-size="9pt" >
				                   </fo:block> 
				      			</fo:table-cell>
				       
				     			<fo:table-cell  text-align="left">
				      				<fo:block  font-family="arial" color="black" font-size="35pt" wrap-option="wrap" >
				      					<xsl:value-of select="data/main/desc21"/><xsl:text> </xsl:text>
				          			</fo:block> 
                     				<fo:block font-family="arial" font-size="9pt" >
				                    </fo:block> 
									<fo:block  text-align="left" font-family="arial" color="black" font-size="22pt" wrap-option="wrap"  padding="2.5mm">
 									  <xsl:value-of select="data/main/desc22"/><xsl:text> </xsl:text>
									</fo:block>
									<fo:block  text-align="left" font-family="arial" color="black" font-size="22pt" wrap-option="wrap" padding="2.5mm" > 
									   <xsl:value-of select="data/main/desc23"/><xsl:text> </xsl:text>
									</fo:block>
									<fo:block  text-align="left" font-family="arial" color="black" font-size="22pt" wrap-option="wrap" padding="2.5mm" > 
										<xsl:value-of select="data/main/desc24"/><xsl:text> </xsl:text>
									</fo:block>
									<fo:block text-align="left" font-family="arial" color="black" font-size="22pt" wrap-option="wrap" padding="2.5mm" >
										<xsl:value-of select="data/main/desc25"/><xsl:text> </xsl:text>
									<fo:basic-link 
   										 external-destination="url('http://internationalsos.com/duty-of-care')" color="blue"> http://internationalsos.com/duty-of-care
									</fo:basic-link>
									</fo:block>
				    			</fo:table-cell>	


								<fo:table-cell >
				         			<fo:block start-indent="0.5cm" >
										<fo:external-graphic  padding-right="1cm" >
											<xsl:attribute name="src">
												<xsl:text>'</xsl:text><xsl:value-of select="data/main/imgPath"/><xsl:text>/</xsl:text>
												<xsl:value-of select="data/main/wallpaper"/><xsl:text>'</xsl:text>
											</xsl:attribute>
											<xsl:attribute name="height">13cm</xsl:attribute>
											<xsl:attribute name="width">16cm</xsl:attribute>
											<xsl:attribute name="align">left</xsl:attribute>
										</fo:external-graphic>
				         			</fo:block>
	      			   			</fo:table-cell>
	      			  
						   </fo:table-row>
						</fo:table-body>
			   </fo:table>
		</fo:block>


         <fo:block text-align="start" line-height="1em + 2pt">
		<fo:table table-layout="fixed" >
				<fo:table-column column-width="0cm"/>
				
				<fo:table-column column-width="0cm"/>
				<fo:table-column column-width="0cm"/> 
				<fo:table-column column-width="cm"/>
			
				<fo:table-body>
				  	<fo:table-row>
                   
 					 <fo:table-cell>

				        <fo:block font-family="arial" font-size="9pt" >
				      
				        </fo:block> 
				     </fo:table-cell>

				    
				     <fo:table-cell text-align="left">
				      	<fo:block font-family="arial" color="black" font-size="35pt" wrap-option="no-wrap" padding="7mm" >
				       <xsl:value-of select="data/main/desc31"/><xsl:text></xsl:text> </fo:block> 
                     	<fo:block font-family="arial" font-size="9pt" >
				      
				     </fo:block> 
 							<fo:block text-align="left" font-family="arial" color="black" font-size="21pt" wrap-option="no-wrap" padding="7mm">
		<xsl:value-of select="data/main/desc32"/><xsl:text></xsl:text><fo:basic-link 
		external-destination="url('http://www.internationalsos.com')" color="blue"> http://www.internationalsos.com
                                                          </fo:basic-link>
                                                      </fo:block>
                                                      <fo:block text-align="left" font-family="arial" color="black" font-size="21pt" wrap-option="no-wrap" padding="2mm">
            <xsl:value-of select="data/main/desc33"/><xsl:text></xsl:text> </fo:block>
          <fo:block text-align="left" font-family="arial" color="black" font-size="21pt" wrap-option="no-wrap" padding="2mm">
            <xsl:value-of select="data/main/desc34"/><xsl:text></xsl:text> </fo:block>

				 </fo:table-cell>	


					</fo:table-row>
					</fo:table-body>
					</fo:table>
					</fo:block>

		
			 <!--Body end-->   
      </fo:flow>
	</fo:page-sequence>
  </fo:root>
 </xsl:template>
</xsl:stylesheet>