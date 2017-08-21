<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	<xsl:template match="root">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="all"
					page-height="23in" page-width="18.5in" margin-top="0.5in"
					margin-bottom="0.5in" margin-left="0.6in" margin-right="0.6in">
					<fo:region-body margin-top="3.9in" margin-bottom="1.0in" />
					<fo:region-before extent="10.2in" />
					<fo:region-after extent="1.2in" />
				</fo:simple-page-master>
			</fo:layout-master-set>
			<!-- Header start -->
			<fo:page-sequence master-reference="all">
				<fo:static-content flow-name="xsl-region-before">
					<fo:block>
						<fo:table width="100%" padding-bottom="-1.5cm">
							<fo:table-column column-width="10%" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block start-indent="34cm">
											<fo:external-graphic display-align="right"
												width="800pt">
												<xsl:attribute name="src">
									<xsl:text>'</xsl:text>
									<xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
									<xsl:value-of select="data/main/Company_Logo" /><xsl:text>'</xsl:text>
								</xsl:attribute>
											</fo:external-graphic>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>

					<fo:block>
						<fo:table>
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="0cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif" font-size="9pt">
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="margin-right">
										<fo:block start-indent="0.2cm" font-family="sans-serif"
											font-weight="bold" color="#2f4696" font-size="47pt"
											wrap-option="no-wrap">
											<xsl:value-of select="data/main/pdf_haading" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>

					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table border-bottom-style="solid"
							border-bottom-width="2pt" padding="2mm">
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="12.35cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif" font-size="9pt">
										</fo:block>
									</fo:table-cell>

									<fo:table-cell text-align="margin-left">
										<fo:block start-indent="-10.2cm" font-family="sans-serif"
											font-size="30pt" color="black" wrap-option="no-wrap"
											padding-bottom="1.2cm">
											<xsl:value-of select="data/main/pdf_sub_haading" />
											<xsl:text> - </xsl:text>
											<fo:inline font-size="25pt">
												<xsl:value-of select="data/main/user" />
												<xsl:text></xsl:text>
											</fo:inline>
											<xsl:text> - </xsl:text>
											<fo:inline font-size="25pt">
												<xsl:value-of select="data/main/companyname" />
												<xsl:text></xsl:text>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- Header end -->
				<!-- footer start -->
				<fo:static-content flow-name="xsl-region-after">
					<fo:block text-align="start" line-height="2em + 2pt"
						wrap-option="no-wrap">
						<fo:table table-layout="fixed" start-indent="-4.4cm">
							<fo:table-column column-width="50cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block start-indent="14cm" padding="4mm">
											<fo:external-graphic display-align="center" width="500pt">
												<xsl:attribute name="src">
													<xsl:text>'</xsl:text>
													<xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
													<xsl:value-of select="data/main/strapline" /><xsl:text>'</xsl:text>
												</xsl:attribute>
											</fo:external-graphic>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- Footer end -->
				<!--Body starts -->

				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates select="data" />
					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table table-layout="fixed" width="300%" space-before="0.5cm"
							border-bottom-style="solid" border-bottom-width="2pt">
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="12.35cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif" font-size="7pt">
										</fo:block>
									</fo:table-cell>

									<fo:table-cell text-align="margin-right">
										<fo:block start-indent="6.5cm" font-family="sans-serif"
											font-weight="bold" color="#019fde" font-size="43pt"
											wrap-option="no-wrap" padding-bottom="6mm" padding-top="-5mm">
											<xsl:value-of select="data/main/pdf_score_text" />
											<xsl:text> </xsl:text>
											<xsl:value-of select="data/main/score" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table table-layout="fixed" space-before="0.8cm"
							width="300%" height="4cm" padding="4mm">
							<fo:table-column column-width="43cm" />
							<fo:table-column column-width="43cm" />
							<fo:table-column column-width="43cm" />
							<fo:table-column column-width="43cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell padding-bottom="10mm">
										<fo:block start-indent="1cm">
											<fo:external-graphic padding-right="1cm">
												<xsl:attribute name="src">
													<xsl:text>'</xsl:text><xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
													<xsl:value-of select="data/main/range" /><xsl:text>'</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="height">120cm</xsl:attribute>
												<xsl:attribute name="width">878cm</xsl:attribute>
												<xsl:attribute name="align">right</xsl:attribute>
											</fo:external-graphic>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell border-top-style="solid" border-top-width="2pt" padding="5mm" text-align="center" >
										<fo:block start-indent="0cm" background-color="#f2f2f2">
											<fo:external-graphic padding-right="1cm" display-align="center">
												<xsl:attribute name="src">
													<xsl:text>'</xsl:text><xsl:value-of	select="data/main/spiderwebImgPath" /><xsl:text>/</xsl:text>
													<xsl:value-of select="data/main/spiderwebFileName" /><xsl:text>'</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="align">center</xsl:attribute>
											</fo:external-graphic>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table table-layout="fixed" width="300%" space-before="0.5cm"
							border-top-style="solid" border-top-width="2pt" padding="-2mm">
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="10.5cm" />
							<fo:table-column column-width="12.35cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
										</fo:block>
									</fo:table-cell>

									<fo:table-cell text-align="margin-right">
										<fo:block>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block text-align="start" padding-top="2cm">
						<fo:table table-layout="fixed" width="80%" padding-top="-2cm">
							<fo:table-column column-width="2.4cm" />
							<fo:table-column column-width="41cm" />
							<fo:table-body>
								<xsl:for-each select="data/main/plan">
									<xsl:variable name="titleColor">
										<xsl:choose>
											<xsl:when test="title='do'">
												<xsl:value-of select="'#009354'" /> <!-- green -->
											</xsl:when>
											<xsl:when test="title='check'">
												<xsl:value-of select="'#6c206b'" /> <!-- purple -->
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'#232762'" /> <!--blue -->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<fo:table-row>
										<fo:table-cell number-columns-spanned="2">
											<fo:block font-family="sans-serif" color="{$titleColor}"
												font-size="40pt" wrap-option="wrap" space-before="1cm"
												font-variant="small-caps">
												<xsl:value-of select="title" />
												<xsl:text>  </xsl:text>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<xsl:for-each select="question">
										<fo:table-row background-color="#f2f2f2"
											padding-top="2cm">
											<fo:table-cell>
												<fo:block font-family="sans-serif" font-size="25pt"
													wrap-option="wrap" font-weight="bold" space-before="1cm"
													margin="1.5cm">
													<xsl:value-of select="title" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-family="sans-serif" color="black"
													font-size="25pt" wrap-option="wrap" font-weight="bold"
													space-before="1cm" margin="1.5cm">
													<xsl:value-of select="value" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row background-color="#f2f2f2">
											<fo:table-cell number-columns-spanned="2">
												<fo:block font-family="sans-serif" color="black"
													font-size="25pt" wrap-option="wrap" space-before="1cm"
													margin="4.0cm">
													<xsl:value-of select="answer" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block>

					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table table-layout="fixed" padding="9mm">
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="26cm" />
							<fo:table-column column-width="26cm" />
							<fo:table-column column-width="29cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif" font-size="9pt">
										</fo:block>
									</fo:table-cell>

								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>

					<fo:block text-align="start" line-height="1em + 2pt">
						<fo:table table-layout="fixed">
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="0cm" />
							<fo:table-column column-width="cm" />

							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif" font-size="9pt">
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="left">
										<fo:block font-family="sans-serif" color="black"
											font-size="35pt" wrap-option="no-wrap" padding="7mm">
											<xsl:value-of select="data/main/desc31" />
											<xsl:text></xsl:text>
										</fo:block>
										<fo:block font-family="sans-serif" font-size="9pt">
										</fo:block>
										<fo:block text-align="left" font-family="sans-serif"
											color="black" font-size="21pt" wrap-option="no-wrap" padding="7mm">
											<xsl:value-of select="data/main/desc32" />
											<xsl:text></xsl:text>
											<xsl:variable name="cmailid" select="data/main/cmailid" />
											<xsl:variable name="curl" select="data/main/curl" />
											<fo:basic-link external-destination="url('{$curl}')"
												color="#019fde">
												<xsl:value-of select="data/main/clink" />
												<xsl:text> </xsl:text>
											</fo:basic-link>
										</fo:block>

										<fo:block text-align="left" font-family="sans-serif"
											color="black" font-size="21pt" wrap-option="no-wrap" padding="2mm">
											<xsl:value-of select="data/main/desc33" />
											<xsl:text></xsl:text>
										</fo:block>
										<fo:block text-align="left" font-family="sans-serif"
											color="black" font-size="21pt" wrap-option="no-wrap" padding="2mm">
											<xsl:value-of select="data/main/desc34" />
											<xsl:text></xsl:text>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<!--Body end -->
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>
