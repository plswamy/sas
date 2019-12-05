<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	<xsl:template match="root">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="all"
					page-height="11.69in" page-width="8.27in" margin-top="10mm"
					margin-bottom="1mm" margin-left="0.6in" margin-right="0.6in">
					<fo:region-body region-name="xsl-region-body"
						margin-top="5.7cm" margin-bottom="2.5cm" />
					<fo:region-before region-name="xsl-region-before"
						extent="5in" />
					<fo:region-after region-name="xsl-region-after"
						extent="1in" />
				</fo:simple-page-master>
			</fo:layout-master-set>
			<!-- Header start -->
			<fo:page-sequence master-reference="all">
				<fo:static-content flow-name="xsl-region-before">
					<fo:block text-align="right">
						<fo:external-graphic width="3.30cm" height="2.11cm" content-width="scale-down-to-fit" content-height="scale-down-to-fit" scaling="non-uniform">
							<xsl:attribute name="src">
							<xsl:text>url('</xsl:text>
							<xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
							<xsl:value-of select="data/main/Company_Logo" /><xsl:text>')</xsl:text>
						</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
					<fo:block padding-top="5mm">
						<fo:block font-family="sans-serif, SimHei" font-weight="bold"
							color="#2f4696" font-size="20pt" wrap-option="no-wrap">
							<xsl:value-of select="data/main/pdf_heading" />
						</fo:block>
					</fo:block>
					<fo:block>
						<fo:block font-family="sans-serif, SimHei" font-size="19pt"
							color="black" wrap-option="no-wrap" padding-bottom="2mm">
							<xsl:value-of select="data/main/pdf_sub_haading" />
							<xsl:text> - </xsl:text>
							<fo:inline font-size="19pt">
								<xsl:value-of select="data/main/user" />
								<xsl:text></xsl:text>
							</fo:inline>
						</fo:block>
					</fo:block>
					<fo:block>
						<fo:block font-family="sans-serif, SimHei" font-size="19pt"
							color="black" wrap-option="no-wrap" padding-bottom="2mm"
							border-bottom-style="solid" border-bottom-width="2pt">
								<xsl:value-of select="data/main/companyname" />
								<xsl:text></xsl:text>
						</fo:block>
					</fo:block>
				</fo:static-content>
				<!-- Header end -->
				<!-- footer start -->
				<fo:static-content flow-name="xsl-region-after">
					<fo:block>
						<fo:block text-align="center">
							<fo:external-graphic height="0.9cm" width="8.4cm" content-width="scale-down-to-fit" content-height="scale-down-to-fit" scaling="non-uniform">
								<xsl:attribute name="src">
									<xsl:text>url('</xsl:text>
									<xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
									<xsl:value-of select="data/main/strapline" /><xsl:text>')</xsl:text>
								</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block>
				</fo:static-content>
				<!-- Footer end -->
				<!--Body starts -->
				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates select="data" />
					<fo:block text-align="center">
						<fo:block font-family="sans-serif, SimHei" font-weight="bold"
							color="#2f4696" font-size="23pt" wrap-option="no-wrap"
							text-align="center" border-bottom-style="solid"
							border-bottom-width="2pt">
							<xsl:value-of select="data/main/pdf_score_text" />
							<xsl:text> </xsl:text>
							<xsl:value-of select="data/main/score" />
						</fo:block>
					</fo:block>
					<fo:block text-align="start" padding-top="5mm"
						padding-bottom="5mm">
						<fo:external-graphic padding-right="0.5cm"
							width="17.7cm" height="3.0cm" content-width="scale-down-to-fit" content-height="scale-down-to-fit" scaling="non-uniform">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text><xsl:value-of select="data/main/imgPath" /><xsl:text>/</xsl:text>
								<xsl:value-of select="data/main/range" /><xsl:text>')</xsl:text>
							</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
					<fo:block background-color="#f2f2f2" text-align="center"
						padding-top="5mm" page-break-after="always">
						<fo:external-graphic width="17.7cm" height="14cm" content-width="scale-down-to-fit" content-height="scale-down-to-fit" scaling="non-uniform">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text><xsl:value-of
								select="data/main/spiderwebImgPath" /><xsl:text>/</xsl:text>
								<xsl:value-of select="data/main/spiderwebFileName" /><xsl:text>')</xsl:text>
							</xsl:attribute>
						</fo:external-graphic>
					</fo:block>
					
					<fo:block text-align="start">
						<fo:table>
							<fo:table-column column-width="1.5cm" />
							<fo:table-column column-width="1cm" />
							<fo:table-column column-width="15.5cm" />
							<fo:table-body>
								<xsl:for-each select="data/main/plan">
									<xsl:variable name="titleColor">
										<xsl:choose>
											<xsl:when test="title[@id='2']">
												<xsl:value-of select="'#009354'" /> <!-- green -->
											</xsl:when>
											<xsl:when test="title[@id='3']">
												<xsl:value-of select="'#6c206b'" /> <!-- purple -->
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'#232762'" /> <!--blue -->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<fo:table-row>
										<fo:table-cell number-columns-spanned="3">
											<fo:block font-family="sans-serif, SimHei" color="{$titleColor}"
												font-size="20pt" wrap-option="wrap" space-before="5mm"
												font-variant="small-caps" font-weight="bold">
												<xsl:value-of select="title" />
												<xsl:text>  </xsl:text>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell number-columns-spanned="3">
											<fo:block font-family="sans-serif, SimHei " color="{$titleColor}"
												font-size="12pt" font-weight="bold" wrap-option="wrap" space-before="5mm"
												font-variant="small-caps">
												<fo:inline color="#232762"><xsl:value-of select="../pdf_section_sub_heading1" /> </fo:inline>
												<fo:inline color="#FF0000"><xsl:value-of select="../pdf_section_sub_heading2" /> </fo:inline>
												<fo:inline color="#232762"><xsl:value-of select="../pdf_section_sub_heading3" />: </fo:inline>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<xsl:for-each select="subsection">
									<fo:table-row>
										<fo:table-cell number-columns-spanned="3">
											<fo:block font-family="sans-serif, SimHei" color="{$titleColor}"
												font-size="12pt" font-weight="bold" wrap-option="wrap" space-before="5mm"
												font-variant="small-caps">
												<xsl:value-of select="title" />
												<xsl:text>  </xsl:text>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<xsl:for-each select="question">
										<fo:table-row background-color="#f2f2f2">
											<fo:table-cell>
												<fo:block padding-top="5mm" padding="3mm">
													<fo:external-graphic width="1cm" height="0.8cm" content-width="scale-down-to-fit" content-height="scale-down-to-fit" scaling="non-uniform">
														<xsl:attribute name="src">
															<xsl:choose>
																<xsl:when test="response = 'true'">
																	<xsl:text>url('</xsl:text>
																	<xsl:value-of select="../../../imgPath" /><xsl:text>/</xsl:text>
																	<xsl:value-of select="../../../correctAnswer" /><xsl:text>')</xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>url('</xsl:text>
																	<xsl:value-of select="../../../imgPath" /><xsl:text>/</xsl:text>
																	<xsl:value-of select="../../../wrongAnswer" /><xsl:text>')</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
													</fo:external-graphic>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-family="sans-serif, SimHei" font-size="10pt"
													color="{$titleColor}" wrap-option="wrap" font-weight="bold" space-before="3mm">
													<xsl:value-of select="title" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-family="sans-serif, SimHei" color="black"
													font-size="10pt" wrap-option="wrap" font-weight="bold" space-before="3mm">
													<xsl:value-of select="value" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row background-color="#f2f2f2">
											<fo:table-cell number-columns-spanned="3">
												<fo:block font-family="sans-serif, SimHei" color="black"
													font-size="9pt" wrap-option="wrap" margin-left="2.5cm">
													<xsl:value-of select="answer" />
													<xsl:text> </xsl:text>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block text-align="start">
						<fo:table>
							<fo:table-column column-width="18cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-family="sans-serif, SimHei" color="black"
											font-size="13pt" wrap-option="no-wrap" padding-top="5mm">
											<xsl:value-of select="data/main/desc31" />
											<xsl:text></xsl:text>
										</fo:block>
										<fo:block text-align="left" font-family="sans-serif, SimHei"
											color="black" font-size="8pt" wrap-option="no-wrap" padding-top="5mm">
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

										<fo:block text-align="left" font-family="sans-serif, SimHei"
											color="black" font-size="8pt" wrap-option="wrap" padding-top="5mm">
											<xsl:value-of select="data/main/desc33" />
											<xsl:text> </xsl:text>
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
