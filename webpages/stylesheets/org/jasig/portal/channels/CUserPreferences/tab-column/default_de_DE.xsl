<?xml version="1.0"?>
<!--
Copyright (c) 2001 The JA-SIG Collaborative.  All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.
   
3. Redistributions of any form whatsoever must retain the following
   acknowledgment:
   "This product includes software developed by the JA-SIG Collaborative
   (http://www.jasig.org/)."
   
THIS SOFTWARE IS PROVIDED BY THE JA-SIG COLLABORATIVE "AS IS" AND ANY
EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE JA-SIG COLLABORATIVE OR
ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Jultin Tilton, jet@immagic.com
$Revision$
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no"/>
  <xsl:param name="baseActionURL">render.userLayoutRootNode.uP</xsl:param>
  <xsl:param name="activeTab">1</xsl:param>
  <xsl:param name="action">no parameter passed</xsl:param>
  <xsl:param name="position">no parameter passed</xsl:param>
  <xsl:param name="elementID">no parameter passed</xsl:param>
  <xsl:param name="errorMessage">no parameter passed</xsl:param>
  <xsl:param name="showLockUnlock">false</xsl:param>
  <xsl:param name="locale">de_DE</xsl:param>
  <xsl:variable name="activeTabID" select="/layout/folder/folder[not(@type='header' or @type='footer') and @hidden='false'][position() = $activeTab]/@ID"/>
  <xsl:variable name="mediaPath">media/org/jasig/portal/channels/CUserPreferences/tab-column</xsl:variable>
  <!--remove for CVS
  <xsl:variable name="mediaPath">C:\portal\webpages\media/org/jasig/portal/channels/CUserPreferences/tab-column</xsl:variable>
  end remove-->

  <xsl:template match="layout">
    <!--remove for CVS
            <html>
      <head>
        <title>uPortal 2.0</title>
        <link type="text/css" rel="stylesheet" href="C:\portal\webpages\media\org\jasig\portal\layout\tab-column\nested-tables\imm\skin\imm.css"/>
      </head>
    end remove-->

    <xsl:for-each select="folder[@type='root']">

    <xsl:call-template name="optionMenu"/>
    <br/>
    <!--Begin Layout Table -->
    <table width="100%" border="0" cellspacing="0" cellpadding="20">
      <tr align="center" valign="top" class="uportal-background-dark">
        <td class="uportal-background-dark">
          <!--Begin Layout Sub-Table -->
          <table summary="add summary" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
                <xsl:call-template name="tabRow"/>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:call-template name="contentRow"/>
              </td>
            </tr>
          </table>
          <!--End Layout Sub-Table -->
        </td>
      </tr>
    </table>
   </xsl:for-each>

    <!--End Layout Table -->
    <!--remove for CVS
    </html>
    end remove-->
  </xsl:template>
  <xsl:template name="tabRow">
    <!--Begin Tab Table -->
    <table summary="add summary" border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <xsl:for-each select="/layout/folder/folder[not(@type='header' or @type='footer') and @hidden='false']">
          <xsl:choose>
            <xsl:when test="not($activeTab = position())">
              <td nowrap="nowrap" class="uportal-background-light">
                <xsl:choose>
                      <xsl:when test="ancestor-or-self::*[@immutable='true']">
                      <img alt="Diese Tabelle ist verriegelt" src="{$mediaPath}/lock.gif" width="16" height="16" border="0"/>
                      </xsl:when>
                  <xsl:when test="not(position()=1)">
                    <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=insertBefore_{preceding-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                      <img alt="Klicken Sie, um diese Tabelle links zu bewegen" src="{$mediaPath}/arrow_left.gif" width="16" height="16" border="0"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/arrow_left_off.gif" width="4" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td nowrap="nowrap" class="uportal-background-light">
                <a class="uportal-text-small">
                  <xsl:choose>
                    <xsl:when test="$action = 'moveColumn' or $action = 'moveChannel'">
                      <xsl:attribute name="href">
                        <xsl:value-of select="$baseActionURL"/>?action=<xsl:value-of select="$action"/>&amp;activeTab=<xsl:value-of select="position()"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$baseActionURL"/>?action=selectTab&amp;activeTab=<xsl:value-of select="position()"/></xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="@name"/>
                </a>
              </td>
              <td nowrap="nowrap" class="uportal-background-light">
                <xsl:choose>
                  <xsl:when test="not(position()=last())">
                    <xsl:choose>
                      <xsl:when test="ancestor-or-self::*[@immutable='true']">
                      <img alt="Diese Tabelle ist verriegelt" src="{$mediaPath}/lock.gif" width="16" height="16" border="0"/>
                      </xsl:when>
                      <xsl:when test="not(position() = (last()-1))">
                        <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=insertBefore_{following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][2]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Tabelle rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=appendAfter_{following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Tabelle rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/transparent.gif" width="4" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="uportal-background-dark">
                <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td nowrap="nowrap" class="uportal-background-content">
                <xsl:choose>
                  <xsl:when test="not(position()=1)">
                    <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=insertBefore_{preceding-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                      <img alt="Klicken Sie, um diese Tabelle links zu bewegen" src="{$mediaPath}/arrow_left.gif" width="16" height="16" border="0"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/transparent.gif" width="4" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td nowrap="nowrap">
                <xsl:choose>
                  <xsl:when test="$action='modifyTab'">
                    <xsl:attribute name="class">uportal-background-highlight</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">uportal-background-content</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <a class="uportal-navigation-category-selected">
                  <xsl:choose>
                    <xsl:when test="$action = 'moveColumn' or $action = 'moveChannel'">
                      <xsl:attribute name="href">
                        <xsl:value-of select="$baseActionURL"/>?action=<xsl:value-of select="$action"/>&amp;activeTab=<xsl:value-of select="position()"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$baseActionURL"/>?action=selectTab&amp;activeTab=<xsl:value-of select="position()"/></xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <span class="uportal-text-small">
                    <xsl:value-of select="@name"/>
                  </span>
                </a>
              </td>
              <td nowrap="nowrap" class="uportal-background-content">
                <xsl:choose>
                  <xsl:when test="not(position()=last())">
                    <xsl:choose>
                      <xsl:when test="ancestor-or-self::*[@immutable='true']">
                      <img alt="Diese Tabelle ist verriegelt" src="{$mediaPath}/lock.gif" width="16" height="16" border="0"/>
                      </xsl:when>
                      <xsl:when test="not(position() = (last()-1))">
                        <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=insertBefore_{following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][2]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Tabelle rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveTab&amp;elementID={@ID}&amp;method_ID=appendAfter_{following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Tabelle rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/transparent.gif" width="16" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="uportal-background-dark">
                <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="$action = 'newTab'">
            <td nowrap="nowrap" bgcolor="#CCCCCC" class="uportal-background-highlight">
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
              <img alt="Schnittstellenbild" src="{$mediaPath}/newtab.gif" width="59" height="20"/>
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="not($action='moveColumn' or $action='moveChannel')">
              <td nowrap="nowrap" bgcolor="#CCCCCC">
                <a href="{$baseActionURL}?action=newTab" class="uportal-text-small">
                  <img alt="Klicken Sie hier, um eine neue Tabelle hinzuzufügen" src="{$mediaPath}/newtab.gif" width="59" height="20" border="0"/>
                </a>
              </td>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <td width="100%">
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="20"/>
        </td>
      </tr>
    </table>
    <!--End Tab Table -->
  </xsl:template>
  <xsl:template name="contentRow">
    <!--Begin Content Table -->
    <table border="0" cellspacing="0" cellpadding="0" class="uportal-background-content" width="100%">
      <xsl:call-template name="controlRow"/>
      <tr>
        <xsl:choose>
          <xsl:when test="/layout/folder/folder[attribute::ID=$activeTabID]/folder">
            <xsl:for-each select="/layout/folder/folder[attribute::ID=$activeTabID]/descendant::folder">
              <xsl:call-template name="contentColumns"/>
              <xsl:if test="position()=last()">
                <xsl:call-template name="closeContentRow"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="/layout/folder/folder[attribute::ID=$activeTabID]">
              <xsl:call-template name="contentColumns"/>
              <xsl:call-template name="closeContentRow"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="controlRow"/>
      </tr>
    </table>
    <!--End Content Table -->
  </xsl:template>
  <xsl:template name="controlRow">
    <!--Begin Control Row -->
    <tr>
      <xsl:choose>
        <xsl:when test="/layout/folder/folder[attribute::ID=$activeTabID]/folder">
          <xsl:for-each select="/layout/folder/folder[attribute::ID=$activeTabID]/folder">
            <td width="10">
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
            </td>
            <td width="20">
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
            </td>
            <td width="10">
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="20"/>
            </td>
            <td width="">
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
            </td>
          </xsl:for-each>
          <td width="10">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="20">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="10">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="20"/>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td width="10">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="20">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="10">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="20"/>
          </td>
          <td width="100%">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="10">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td width="20">
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
          </td>
          <td>
            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="20"/>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
    <!--End Control Row -->
  </xsl:template>
  <xsl:template name="optionMenu">
    <!--Begin Option Menu-->
    <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
      <tr class="uportal-background-light">
        <td class="uportal-channel-text">
          <xsl:choose>
            <xsl:when test="$action='selectTab'">
              <xsl:call-template name="optionMenuModifyTab"/>
            </xsl:when>
            <xsl:when test="$action='selectColumn'">
              <xsl:call-template name="optionMenuModifyColumn"/>
            </xsl:when>
            <xsl:when test="$action='selectChannel'">
              <xsl:call-template name="optionMenuModifyChannel"/>
            </xsl:when>
            <xsl:when test="$action='newTab'">
              <xsl:call-template name="optionMenuNewTab"/>
            </xsl:when>
            <xsl:when test="$action='newColumn'">
              <xsl:call-template name="optionMenuNewColumn"/>
            </xsl:when>
            <xsl:when test="$action='moveColumn'">
              <xsl:call-template name="optionMenuMoveColumn"/>
            </xsl:when>
            <xsl:when test="$action='moveChannel'">
              <xsl:call-template name="optionMenuMoveChannel"/>
            </xsl:when>
            <xsl:when test="$action='error'">
              <xsl:call-template name="optionMenuError"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="optionMenuDefault"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
    <!--End Option Menu-->
  </xsl:template>
  <xsl:template name="contentColumns">
    <xsl:call-template name="controlColumn"/>
    <xsl:call-template name="newColumn"/>
    <xsl:call-template name="controlColumn"/>
    <!--Begin Content Column -->
    <td align="center" valign="top">
      <xsl:if test="($action = 'selectColumn' or $action = 'moveColumn') and $elementID=@ID">
        <xsl:attribute name="class">uportal-background-highlight</xsl:attribute>
      </xsl:if>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <!--Begin [select Column]row -->
        <tr>
          <td class="uportal-background-light" width="100%" align="center">
            <xsl:choose>
              <xsl:when test="($action = 'selectColumn' or $action = 'moveColumn') and $elementID=@ID">
                <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="20" height="20"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="not(position()=1) and ancestor-or-self::*[@immutable='true']">
                  <img alt="Diese Spalte ist verriegelt" src="{$mediaPath}/lock.gif" width="16" height="16" border="0"/>
                  </xsl:when>
                  <xsl:when test="not(position()=1)">
                    <a href="{$baseActionURL}?action=moveColumnHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={preceding-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                      <img alt="Klicken Sie, um diese Spalte nach links zu bewegen" src="{$mediaPath}/arrow_left.gif" width="16" height="16" border="0"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/transparent.gif" width="16" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
                <a href="{$baseActionURL}?action=selectColumn&amp;elementID={@ID}" class="uportal-text-small">
                  <img alt="Klicken Sie, um diese Spalte zu wählen" src="{$mediaPath}/selectcolumn.gif" width="79" height="20" border="0"/>
                </a>
                <xsl:choose>
                  <xsl:when test="not(position()=last())">
                    <xsl:choose>
                      <xsl:when test="ancestor-or-self::*[@immutable='true']">
                      <img alt="Diese Spalte ist verriegelt" src="{$mediaPath}/lock.gif" width="16" height="16" border="0"/>
                      </xsl:when>
                      <xsl:when test="not(position() = (last()-1))">
                        <a href="{$baseActionURL}?action=moveColumnHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][2]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Spalte nach rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveColumnHere&amp;sourceID={@ID}&amp;method=appendAfter&amp;elementID={following-sibling::folder[not(@type='header' or @type='footer') and @hidden='false'][1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diese Spalte nach rechts zu bewegen" src="{$mediaPath}/arrow_right.gif" width="16" height="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/transparent.gif" width="16" height="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--End [select Column] row -->
      </table>
      <xsl:choose>
        <xsl:when test="not(descendant::channel)">
          <xsl:call-template name="newChannel"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="descendant::channel">
            <xsl:call-template name="newChannel"/>
            <xsl:call-template name="selectChannel"/>
            <xsl:if test="position()=last()">
              <xsl:call-template name="closeContentColumn"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <!--End Content Column -->
  </xsl:template>
  <xsl:template name="closeContentRow">
    <!-- Close Content Row-->
    <td>
      <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
    </td>
    <xsl:choose>
      <xsl:when test="$action = 'newColumn' and $position='after'">
        <td class="uportal-background-highlight" width="20">
          <a href="{$baseActionURL}?action=newColumn&amp;method=appendAfter&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="Klicken Sie, um eine neue Spalte in dieser Position hinzuzufügen [nach {@ID}]" src="{$mediaPath}/newcolumn.gif" width="20" height="100" border="0"/>
          </a>
        </td>
      </xsl:when>
      <xsl:when test="$action = 'moveColumn' and not(@ID=$elementID)">
        <td class="uportal-background-highlight" width="20">
          <a href="{$baseActionURL}?action=moveColumnHere&amp;method=appendAfter&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="klicken Sie, um die ausgewählte Spalte auf diese Position zu verschieben [nach {@ID}]" src="{$mediaPath}/movecolumn.gif" border="0"/>
          </a>
        </td>
      </xsl:when>
      <xsl:when test="$action = 'moveColumn' and @ID=$elementID">
        <td class="uportal-background-light" width="20" valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="20" height="20"/>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="uportal-background-light" width="20" valign="top">
          <a href="{$baseActionURL}?action=newColumn&amp;method=appendAfter&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="Klicken Sie, um eine neue Spalte in dieser Position hinzuzufügen [nach {@ID}]" src="{$mediaPath}/newcolumn.gif" width="20" height="100" border="0"/>
          </a>
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <td>
      <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
    </td>
    <!-- Close Content Row-->
  </xsl:template>
  <xsl:template name="controlColumn">
    <td>
      <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
    </td>
  </xsl:template>
  <xsl:template name="newColumn">
    <xsl:choose>
      <xsl:when test="$action = 'newColumn' and $position='before' and $elementID=@ID">
        <td class="uportal-background-highlight" width="20">
          <a href="{$baseActionURL}?action=newColumn&amp;method=insertBefore&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="Klicken Sie, um eine neue Spalte in dieser Position hinzuzufügen [vor {@ID}]" src="{$mediaPath}/newcolumn.gif" width="20" height="100" border="0"/>
          </a>
        </td>
      </xsl:when>
      <xsl:when test="$action = 'moveColumn' and not(@ID=$elementID or preceding-sibling::folder[1]/@ID=$elementID)">
        <td class="uportal-background-highlight" width="20">
          <a href="{$baseActionURL}?action=moveColumnHere&amp;method=insertBefore&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="Klicken Sie, um die ausgewählte Spalte auf diese Position zu verschieben [vor {@ID}]" src="{$mediaPath}/movecolumn.gif" border="0"/>
          </a>
        </td>
      </xsl:when>
      <xsl:when test="$action = 'moveColumn' and (@ID=$elementID or preceding-sibling::folder[1]/@ID=$elementID)">
        <td class="uportal-background-light" width="20" valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="20" height="20"/>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="uportal-background-light" width="20" valign="top">
          <a href="{$baseActionURL}?action=newColumn&amp;method=insertBefore&amp;elementID={@ID}" class="uportal-text-small">
            <img alt="Klicken Sie hier, um eine neue Spalte hinzuzufügen" src="{$mediaPath}/newcolumn.gif" width="20" height="100" border="0"/>
          </a>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="newChannel">
    <!--Begin [new channel] Table -->
    <table width="100%" border="0" cellspacing="10" cellpadding="0">
      <tr>
        <td>
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr align="center">
        <xsl:choose>
          <xsl:when test="$action = 'newChannel' and $position='before' and $elementID=@ID">
            <td class="uportal-background-highlight">
              <a href="{$baseActionURL}?action=newChannel&amp;position=before&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie, um einen neuen Channel in dieser Position hinzuzufügen [vor {@ID}]" src="{$mediaPath}/newchannel.gif" border="0"/>
              </a>
            </td>
          </xsl:when>
          <xsl:when test="$action = 'moveChannel' and not(@ID=$elementID or preceding-sibling::channel[1]/@ID=$elementID)">
            <td class="uportal-background-highlight">
              <a href="{$baseActionURL}?action=moveChannelHere&amp;method=insertBefore&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie, um die ausgewählte Spalte auf diese Position zu verschieben [vor {@ID}]" src="{$mediaPath}/movechannel.gif" border="0"/>
              </a>
            </td>
          </xsl:when>
          <xsl:when test="$action = 'moveChannel' and (@ID=$elementID or preceding-sibling::channel[1]/@ID=$elementID)">
            <td>
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="20" height="20"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <a href="{$baseActionURL}?action=newChannel&amp;position=before&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie hier, um einen neuen Channel hinzuzufügen" src="{$mediaPath}/newchannel.gif" border="0"/>
              </a>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr>
        <td>
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
    <!--End [new channel] Table -->
  </xsl:template>
  <xsl:template name="selectChannel">
    <!--Begin [select channel] Table -->
<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" WIDTH="100%">
<tr><td ALIGN="CENTER">
<xsl:if test="($action = 'selectChannel' or $action = 'moveChannel') and $elementID=@ID">
        <xsl:attribute name="class">uportal-background-highlight</xsl:attribute>
      </xsl:if>
<TABLE CELLPADDING="5" CELLSPACING="0" BORDER="0" ALIGN="CENTER" WIDTH="100%">

           <TR><TD ALIGN="CENTER"><IMG SRC="{$mediaPath}/transparent.gif" WIDTH="1" HEIGHT="1"/></TD></TR>
           <TR>
                <TD ALIGN="CENTER" CLASS="uportal-channel-text"><B>
                <A HREF="{$baseActionURL}?action=selectChannel&amp;elementID={@ID}" onMouseover="window.status=''; return true;">
                
                  <xsl:if test="@name = ''">Kein Channelname</xsl:if>
                  <xsl:value-of select="@name"/>
                </A>
                </B></TD>
           </TR>
        </TABLE>
	<TABLE CELLPADDING="1" CELLSPACING="0" BORDER="0" WIDTH="120" HEIGHT="110">

	   <TR>
	        <TD VALIGN="TOP" style="background-image: url({$mediaPath}/channel/chan_box_bg.gif)">
	        <DIV ALIGN="RIGHT">
		<A HREF="{$baseActionURL}?action=selectChannel&amp;elementID={@ID}" onMouseover="window.status=''; return true;">
		  <IMG SRC="{$mediaPath}/channel/chan_select.gif" ALT="Klicken Sie, um diesen Channel zu wählen" WIDTH="16" HEIGHT="16" BORDER="0" VSPACE="2"/>
		</A>
    <xsl:choose>
<xsl:when test="not(@unremovable='true') and not(ancestor-or-self::*[@immutable='true'])">
		<A HREF="{$baseActionURL}?action=deleteChannel&amp;elementID={@ID}" onClick="return confirm('Sind Sie sicher dass Sie diesen Channel löschen möchten??')" onMouseover="window.status=''; return true;">
		  <IMG SRC="{$mediaPath}/channel/chan_remove.gif" ALT="Klicken Sie um diesen Channel zu löschen" WIDTH="16" HEIGHT="16" BORDER="0" HSPACE="2" VSPACE="2"/>
		</A>
        </xsl:when>
        <xsl:otherwise>
		<IMG ALT="" SRC="{$mediaPath}/channel/chan_remove_na.gif" WIDTH="16" HEIGHT="16" BORDER="0" HSPACE="2" VSPACE="2"/>
        </xsl:otherwise>
    </xsl:choose>
		</DIV>
		<DIV ALIGN="CENTER">
    <IMG SRC="{$mediaPath}/transparent.gif" WIDTH="1" HEIGHT="9"/><BR/>
<!-- Move Channel Up -->
                <xsl:choose>
                  <xsl:when test="not(position()=1) and ancestor-or-self::*[@immutable='true']">
                  <img alt="Dieser Channel ist verriegelt" src="{$mediaPath}/channel/arrow_up_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:when>
                  <xsl:when test="not(position()=1)">
                    <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={preceding-sibling::channel[not(@hidden='true')][1]/@ID}" class="uportal-text-small">
                      <img alt="Klicken Sie, um diesen Channel nach oben zu bewegen" src="{$mediaPath}/channel/arrow_up.gif" WIDTH="16" HEIGHT="16" border="0"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/channel/arrow_up_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
<!-- End Move Channel Up -->
</DIV>
		<DIV ALIGN="CENTER">
<!-- Move Channel Left -->
                <xsl:choose>
                  <xsl:when test="not(../../folder[1]/@ID = parent::folder/@ID) and ancestor-or-self::*[@immutable='true']">
                  <img alt="Dieser Channel ist verriegelt" src="{$mediaPath}/channel/arrow_left_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:when>
                  <xsl:when test="not(../../folder[1]/@ID = parent::folder/@ID)">
                    <xsl:choose>
                      <xsl:when test="parent::folder/preceding-sibling::folder[1]/channel[1]/@ID">
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={parent::folder/preceding-sibling::folder[1]/channel[1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel an den Anfang der vorhergehenden Spalte zu verschieben" src="{$mediaPath}/channel/arrow_left.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={parent::folder/preceding-sibling::folder[1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel an den Anfang der vorhergehenden Spalte zu verschieben" src="{$mediaPath}/channel/arrow_left.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/channel/arrow_left_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
<!-- End Move Channel Left -->
		<IMG SRC="{$mediaPath}/transparent.gif" WIDTH="50" HEIGHT="16" VSPACE="1"/>
<!-- Right Arrow -->
                <xsl:choose>
                  <xsl:when test="not(../../folder[position()=last()]/@ID = parent::folder/@ID) and ancestor-or-self::*[@immutable='true']">
                  <img alt="Dieser Channel ist verriegelt" src="{$mediaPath}/channel/arrow_right_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:when>
                  <xsl:when test="not(../../folder[position()=last()]/@ID = parent::folder/@ID)">
                    <xsl:choose>
                      <xsl:when test="parent::folder/following-sibling::folder[1]/channel[1]/@ID">
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={parent::folder/following-sibling::folder[1]/channel[1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel an den Anfang der nächsten Spalte zu verschieben" src="{$mediaPath}/channel/arrow_right.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={parent::folder/following-sibling::folder[1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel an den Anfang der nächsten Spalte zu verschieben" src="{$mediaPath}/channel/arrow_right.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/channel/arrow_right_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
<!-- End Right Arrow -->
<!-- Moved 002 -->
	        </DIV>
	        <DIV ALIGN="CENTER">
<!-- Down Arrow -->
                <xsl:choose>
                  <xsl:when test="not(position()=last()) and ancestor-or-self::*[@immutable='true']">
                  <img alt="Dieser Channel ist verriegelt" src="{$mediaPath}/channel/arrow_down_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:when>
                  <xsl:when test="not(position()=last())">
                    <xsl:choose>
                      <xsl:when test="not(position() = (last()-1))">
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=insertBefore&amp;elementID={following-sibling::channel[not(@hidden='true')][2]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel nach unten zu bewegen" src="{$mediaPath}/channel/arrow_down.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <a href="{$baseActionURL}?action=moveChannelHere&amp;sourceID={@ID}&amp;method=appendAfter&amp;elementID={following-sibling::channel[not(@hidden='true')][1]/@ID}" class="uportal-text-small">
                          <img alt="Klicken Sie, um diesen Channel nach unten zu bewegen" src="{$mediaPath}/channel/arrow_down.gif" WIDTH="16" HEIGHT="16" border="0"/>
                        </a>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <img alt="" src="{$mediaPath}/channel/arrow_down_na.gif" WIDTH="16" HEIGHT="16" border="0"/>
                  </xsl:otherwise>
                </xsl:choose>
<!-- End Down Arrow -->
	        </DIV>
	        </TD>
	   </TR>
	</TABLE></td></tr></TABLE>
    <!--End [select channel] Table -->
  </xsl:template>
  <xsl:template name="closeContentColumn">
    <!--Begin [new channel] Table -->
    <table width="100%" border="0" cellspacing="10" cellpadding="0">
      <tr align="center">
        <xsl:choose>
          <xsl:when test="$action = 'newChannel' and $position='after' and $elementID=@ID">
            <td class="uportal-background-highlight">
              <a href="{$baseActionURL}?action=newChannel&amp;position=after&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie, um einen neuen Channel in dieser Position hinzuzufügen [nach {@ID}]" src="{$mediaPath}/newchannel.gif" border="0"/>
              </a>
            </td>
          </xsl:when>
          <xsl:when test="$action = 'moveChannel' and not(@ID=$elementID)">
            <td class="uportal-background-highlight">
              <a href="{$baseActionURL}?action=moveChannelHere&amp;method=appendAfter&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie, um den ausgewählten Channel auf diese Position zu verschieben [nach {@ID}]" src="{$mediaPath}/movechannel.gif" border="0"/>
              </a>
            </td>
          </xsl:when>
          <xsl:when test="$action = 'moveChannel' and @ID=$elementID">
            <td>
              <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="20" height="20"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <a href="{$baseActionURL}?action=newChannel&amp;position=after&amp;elementID={@ID}" class="uportal-text-small">
                <img alt="Klicken Sie, um einen neuen Channel in dieser Position hinzuzufügen [nach {@ID}]" src="{$mediaPath}/newchannel.gif" border="0"/>
              </a>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </table>
    <!--End [new channel] Table -->
  </xsl:template>
  <xsl:template name="optionMenuDefault">
    <p>
      <span class="uportal-channel-subtitle-reversed">Optionen für Änderungen der Einstellungen:</span>
    </p>
    <table class="uportal-channel-text" width="100%">
      <tr>
        <td colspan="2">Steuern Sie zu einer Tabelle, oder wählen Sie ein Element auf der aktuellen Tabelle aus, indem Sie unten eine der grauen Tasten klicken. Klicken Sie zum Beispiel einen der<img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="6" height="6" border="0"/>
        <img alt="Schnittstellenbild" src="{$mediaPath}/newchannel.gif" width="79" height="20"/>
        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="6" height="6" border="0"/>
         Buttons, um einen neuen Channel in diese Position hinzuzufügen.</td>
      </tr>
      <tr>
        <td colspan="2">
          <hr/>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td class="uportal-channel-text">
          <a href="{$baseActionURL}?action=manageSkins">Wählen Sie eine skin</a>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td class="uportal-channel-text" width="100%">
          <a href="{$baseActionURL}?action=resetLayout" onClick="return confirm('You are about to replace your current layout with a default layout.  You cannot undo these changes.  Do you want to continue?')">Revert to default layout</a>
        </td>
      </tr>      
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td class="uportal-channel-text" width="100%">
          <a href="{$baseActionURL}?userPreferencesAction=manageProfiles">Profile verwalten [fortgeschritten]</a>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="optionMenuModifyTab">
    <!-- Begin Mod Tab Options -->
    <xsl:variable name="tabName" select="/layout/folder/folder[@ID=$activeTabID]/@name"/>
    <p>
      <span class="uportal-channel-subtitle-reversed">Optionen zum Ändern dieser Tabelle:</span>
    </p>
    <table width="100%" border="0" cellspacing="0" cellpadding="2" class="uportal-channel-text">
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td width="100%">
          <a href="{$baseActionURL}?action=setActiveTab&amp;tab={$activeTab}">Diesen als Standard wählen \"Active Tab\" (die Tabelle wird ausgewählt, wenn Sie sich in das Portal einloggen)</a>
        </td>
      </tr>
      <xsl:if test="not(/layout/folder/folder[@ID=$activeTabID]/@immutable = 'true')">
        <tr>
          <td valign="top">
            <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
          </td>
          <td>
            <form name="formRenameTab" method="post" action="{$baseActionURL}">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="uportal-channel-text">
                <tr>
                  <td nowrap="nowrap">
                    <a href="#">Umbennen der Tabelle:<img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/></a>
                  </td>
                  <td width="100%">
                    <input type="text" name="tabName" value="{$tabName}" class="uportal-input-text" size="30"/>
                    <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                    <input type="submit" name="RenameTab" value="Umbenennen" class="uportal-button"/>
                    <input type="hidden" name="action" value="renameTab"/>
                    <input type="hidden" name="elementID" value="{$activeTabID}"/>
                  </td>
                </tr>
              </table>
            </form>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td>
          <a href="#">Verschieben Sie diese Tabelle auf eine andere Position: (Wählen Sie unten aus und klicken Sie dann den 'Bewegen'-Knopf )</a>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <form name="formMoveTab" method="post" action="{$baseActionURL}">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="uportal-channel-text">
              <tr>
                <xsl:for-each select="/layout/folder/folder[not(@type='header' or @type='footer') and @hidden='false']">
                  <xsl:choose>
                    <xsl:when test="@ID=$activeTabID">
                      <td class="uportal-background-light">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                      </td>
                      <td nowrap="nowrap" class="uportal-background-content">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                        <span class="uportal-text-small">
                          <xsl:value-of select="@name"/>
                        </span>
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                      </td>
                      <td class="uportal-background-light">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                      </td>
                    </xsl:when>
                    <xsl:when test="preceding-sibling::*[@hidden = 'false'][1]/@ID=$activeTabID">
                      <xsl:choose>
                        <xsl:when test="position() = last()">
                          <td nowrap="nowrap" class="uportal-background-med">
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                            <span class="uportal-text-small">
                              <xsl:value-of select="@name"/>
                            </span>
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                          </td>
                          <td nowrap="nowrap" class="uportal-background-light">
                            <input type="radio" name="method_ID" value="appendAfter_{@ID}"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td nowrap="nowrap" class="uportal-background-med">
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                            <span class="uportal-text-small">
                              <xsl:value-of select="@name"/>
                            </span>
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="position()=last()">
                      <td nowrap="nowrap" class="uportal-background-light">
                        <input type="radio" name="method_ID" value="insertBefore_{@ID}"/>
                      </td>
                      <td nowrap="nowrap" class="uportal-background-med">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                        <span class="uportal-text-small">
                          <xsl:value-of select="@name"/>
                        </span>
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                      </td>
                      <td nowrap="nowrap" class="uportal-background-light">
                        <input type="radio" name="method_ID" value="appendAfter_{@ID}"/>
                      </td>
                    </xsl:when>
                    <xsl:otherwise>
                      <td nowrap="nowrap" class="uportal-background-light">
                        <input type="radio" name="method_ID" value="insertBefore_{@ID}"/>
                      </td>
                      <td nowrap="nowrap" class="uportal-background-med">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                        <span class="uportal-text-small">
                          <xsl:value-of select="@name"/>
                        </span>
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                      </td>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
                <td width="100%">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                  <input type="submit" name="MoveTab" value="Move" class="uportal-button"/>
                  <input type="hidden" name="action" value="moveTab"/>
                  <input type="hidden" name="elementID" value="{$activeTabID}"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
      </tr>
      <!-- Add the lock/unlock icon if the user is allowed to make things immutable -->
      <xsl:if test="$showLockUnlock = 'true'">
        <tr>
          <td valign="top">
            <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
          </td>
          <xsl:choose>
            <xsl:when test="/layout/folder/folder[@ID=$activeTabID]/@unremovable = 'true'">
              <td>
                <a href="{$baseActionURL}?action=unlockTab&amp;elementID={$activeTabID}">Entriegeln Sie diese Tabelle</a>
              </td>
            </xsl:when>
            <xsl:when test="/layout/folder/folder[@ID=$activeTabID]/@unremovable = 'false'">
              <td>
                <a href="{$baseActionURL}?action=lockTab&amp;elementID={$activeTabID}">Verriegeln Sie diese Tabelle</a>
              </td>
            </xsl:when>
          </xsl:choose>
        </tr>
      </xsl:if>
      <xsl:if test="not(/layout/folder/folder[@ID=$activeTabID]/@unremovable = 'true')">
        <tr>
          <td valign="top">
            <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
          </td>
          <td>
            <a href="{$baseActionURL}?action=deleteTab&amp;elementID={$activeTabID}">Löschen Sie diese Tabelle</a>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td colspan="2">
          <hr/>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
        </td>
        <td>
          <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
        </td>
      </tr>
    </table>
    <!-- End Mod Tab Options -->
  </xsl:template>
  <xsl:template name="optionMenuModifyColumn">
    <!-- Begin Mod Column Options -->
    <form name="formColumnWidth" method="post" action="{$baseActionURL}">
      <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-channel-text">
        <tr class="uportal-background-light">
          <td class="uportal-channel-text">
            <p>
              <span class="uportal-channel-subtitle-reversed">Optionen zum Ändern dieser Spalte:</span>
            </p>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                </td>
                <td width="100%" class="uportal-channel-text">
                  <a href="#">Ändern Sie die Breite der Spalten (Die Breite der Spalten sollten 100\% ergeben):</a>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                </td>
                <td class="uportal-channel-text">
                  <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr valign="top">
                      <td nowrap="nowrap" align="center">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                      </td>
                      <input type="hidden" name="action" value="columnWidth"/>
                      <xsl:for-each select="/layout/folder/folder[@ID = $activeTabID]/descendant::folder">
                        <td nowrap="nowrap" align="center" class="uportal-text-small">
                          <input type="text" name="columnWidth_{@ID}" value="{@width}" size="5" maxlength="" class="uportal-input-text"/>
                          <br/>
                          <xsl:choose>
                            <xsl:when test="$elementID=@ID">
                              <strong>Column</strong>
                            </xsl:when>
                            <xsl:otherwise>Column</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td nowrap="nowrap">
                          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                        </td>
                      </xsl:for-each>
                      <td width="100%" align="left" nowrap="nowrap">
                        <input type="submit" name="submitModifyColumn" Wert="Submit" class="uportal-button"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <!-- If ancestor is immutable - the column cannot be moved-->
              <xsl:if test="not(/layout/folder/descendant::folder[@ID=$elementID]/ancestor::*[@immutable='true'])">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                  </td>
                  <td class="uportal-channel-text">
                    <a href="{$baseActionURL}?action=moveColumn&amp;elementID={$elementID}">Verschieben Sie diese Spalte auf eine andere Position</a>
                  </td>
                </tr>
              </xsl:if>
              <!-- If ancestor or self is unremovable - the column cannot be deleted-->
              <xsl:if test="not(/layout/folder/descendant::folder[@ID=$elementID]/ancestor-or-self::*[@unremovable='true'])">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                  </td>
                  <td class="uportal-channel-text">
                    <a href="{$baseActionURL}?action=deleteColumn&amp;elementID={$elementID}">Löschen Sie diese Spalte</a>
                  </td>
                </tr>
              </xsl:if>
              <tr>
                <td colspan="2" class="uportal-channel-text">
                  <hr/>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                </td>
                <td class="uportal-channel-text">
                  <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
    <!-- End Mod Column Options -->
  </xsl:template>
  <xsl:template name="optionMenuModifyChannel">
    <xsl:variable name="channelName" select="/layout/folder/folder/descendant::*[@ID = $elementID]/@name"/>
    <form name="formModifyChannel" method="post" action="{$baseActionURL}">
      <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
        <tr class="uportal-background-light">
          <td class="uportal-channel-text">
            <p>
              <span class="uportal-channel-subtitle-reversed">Optionen zum Ändern dieses Channels:</span>
            </p>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <!-- We aren't going to allow renaming a channel at the moment...
              <xsl:if test="not(/layout/folder/descendant::channel[@ID=$elementID]/@immutable = 'true')">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0" />
                  </td>
                  <td width="100%" class="uportal-channel-text">
                    <a href="#">Benennen Sie diesen Channel um :</a>
                    <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0" />
                    <input type="hidden" name="action" value="renameChannel" />
                    <input type="hidden" name="elementID" value="{$elementID}" />
                    <input type="text" name="channelName" class="uportal-input-text" value="{$channelName}" size="30" />
                    <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0" />
                    <input type="submit" name="RenameTab" value="Umbenennen" class="uportal-button" />
                  </td>
                </tr>
              </xsl:if>
              End of channel rename section-->
              <!-- If ancestor is immutable - the channel cannot be moved-->
              <xsl:if test="not(/layout/folder/descendant::*[@ID=$elementID]/ancestor::folder[@immutable='true'])">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                  </td>
                  <td width="100%" class="uportal-channel-text">
                    <a href="{$baseActionURL}?action=moveChannel&amp;elementID={$elementID}">Verschieben Sie diesen Channel auf eine andere Position</a>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="//channel[@ID=$elementID]/parameter/@override = 'yes'">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                  </td>
                  <td width="100%" class="uportal-channel-text">
                    <a href="{$baseActionURL}?action=selectChannel&amp;subAction=modifyChannelParams&amp;elementID={$elementID}">Ändern dieser Channelparameter</a>
                  </td>
                </tr>
              </xsl:if>
              <!-- If ancestor or self is unremovable - the channel cannot be deleted-->
              <xsl:if test="not(/layout/folder/descendant::*[@ID=$elementID]/ancestor-or-self::*[@unremovable='true'])">
                <tr>
                  <td class="uportal-channel-text">
                    <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                  </td>
                  <td width="100%" class="uportal-channel-text">
                    <a href="{$baseActionURL}?action=deleteChannel&amp;elementID={$elementID}">Löschen Sie diesen Channel</a>
                  </td>
                </tr>
              </xsl:if>
              <tr>
                <td colspan="2" class="uportal-channel-text">
                  <hr/>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
                </td>
                <td width="100%" class="uportal-channel-text">
                  <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  <xsl:template name="optionMenuNewTab">
    <form name="formNewTab" method="post" action="{$baseActionURL}">
      <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
        <tr class="uportal-background-light">
          <td class="uportal-channel-text">
            <p>
              <span class="uportal-channel-subtitle-reversed">Schritte für das Einfügen dieser neuen Tabelle:</span>
            </p>
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td class="uportal-channel-text" align="right">
                  <strong>1.</strong>
                </td>
                <td class="uportal-channel-text">Name the tab:<img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/><input type="text" name="tabName" class="uportal-input-text" size="30"/></td>
              </tr>
              <tr>
                <td class="uportal-channel-text" align="right">
                  <strong>
                    <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="16"/>2.</strong>
                </td>
                <td class="uportal-channel-text">Wählen Sie eine Position für die Tabelle aus:</td>
              </tr>
              <tr>
                <td class="uportal-channel-text" align="right">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                </td>
                <td class="uportal-channel-text">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <xsl:for-each select="/layout/folder/folder[not(@type='header' or @type='footer') and @hidden='false']">
                        <td nowrap="nowrap" class="uportal-background-light">
                          <input type="radio" name="method_ID" value="insertBefore_{@ID}"/>
                        </td>
                        <td nowrap="nowrap" class="uportal-background-med">
                          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10" border="0"/>
                          <span class="uportal-text-small">
                            <xsl:value-of select="@name"/>
                          </span>
                          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/>
                        </td>
                      </xsl:for-each>
                      <td width="100%">
                        <input type="radio" name="method_ID" value="appendAfter_{/layout/folder/folder[not(@type='header' or @type='footer') and @hidden='false'][position() = last()]/@ID}"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text" align="right">
                  <strong>3.</strong>
                </td>
                <td class="uportal-channel-text">Entscheidungen einreichen:<input type="hidden" name="action" value="addTab"/><input type="submit" name="Submit" Wert="Submit" class="uportal-button"/></td>
              </tr>
              <tr>
                <td colspan="2" class="uportal-channel-text">
                  <hr/>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16"/>
                </td>
                <td width="100%" class="uportal-channel-text">
                  <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  <xsl:template name="optionMenuNewColumn">
    <form name="formNewColumn" method="post" action="">
      <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
        <tr class="uportal-background-light">
          <td class="uportal-channel-text">
            <p>
              <span class="uportal-channel-subtitle-reversed">Schritte für das Einfügen dieser neuen Spalte:</span>
            </p>
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td class="uportal-channel-text">
                  <strong>1.</strong>
                </td>
                <td class="uportal-channel-text">Stellen Sie die Breite der Spalten ein (Die Breite der Spalten sollten insgesamt 100\% ergeben):</td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-channel-text">
                  <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    <tr valign="top">
                      <td nowrap="nowrap" align="center">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                      </td>
                      <input type="hidden" name="action" value="columnWidth"/>
                      <xsl:for-each select="/layout/folder/folder[@ID = $activeTabID]/descendant::folder">
                        <xsl:if test="$position='before' and $elementID=@ID">
                          <td nowrap="nowrap" align="center" class="uportal-text-small">
                            <input type="text" name="columnWidth_{@ID}" value="" size="5" maxlength="" class="uportal-input-text"/>
                            <br/>
                            <strong>New Column</strong>
                          </td>
                          <td nowrap="nowrap">
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                          </td>
                        </xsl:if>
                        <td nowrap="nowrap" align="center" class="uportal-text-small">
                          <input type="text" name="columnWidth_{@ID}" value="{@width}" size="5" maxlength="" class="uportal-input-text"/>
                          <br/>Column</td>
                        <td nowrap="nowrap">
                          <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                        </td>
                        <xsl:if test="$position='after' and $elementID=@ID">
                          <td nowrap="nowrap" align="center" class="uportal-text-small">
                            <input type="text" name="columnWidth_{@ID}" value="" size="5" maxlength="" class="uportal-input-text"/>
                            <br/>
                            <strong>New Column</strong>
                          </td>
                          <td nowrap="nowrap">
                            <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="16" height="16"/>
                          </td>
                        </xsl:if>
                      </xsl:for-each>
                      <td width="100%" align="left" nowrap="nowrap">
                        <img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="1" height="1"/>
                      </td>
                    </tr>
                    <tr valign="top" class="uportal-text-small">
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <strong>2.</strong>
                </td>
                <td class="uportal-channel-text">Entscheidungen einreichen:<img alt="Schnittstellenbild" src="{$mediaPath}/transparent.gif" width="10" height="10"/><input type="submit" name="submitNewColumn" Wert="Submit" class="uportal-button"/></td>
              </tr>
              <tr>
                <td class="uportal-channel-text" colspan="2">
                  <hr/>
                </td>
              </tr>
              <tr>
                <td class="uportal-channel-text">
                  <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16"/>
                </td>
                <td class="uportal-channel-text" width="100%">
                  <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  <xsl:template name="optionMenuMoveColumn">
    <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
      <tr class="uportal-background-light">
        <td class="uportal-channel-text">
          <p>
            <span class="uportal-channel-subtitle-reversed">Optionen um diese Spalte zu bewegen:</span>
          </p>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="uportal-channel-text">
                <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
              </td>
              <td class="uportal-channel-text">
                <a href="#">Wählen Sie einen der hervorgehobenen Positionen unten aus, oder wählen Sie eine andere Tabelle aus wo diese Spalte plaziert werden soll</a>
              </td>
            </tr>
            <tr>
              <td class="uportal-channel-text" colspan="2">
                <hr/>
              </td>
            </tr>
            <tr>
              <td class="uportal-channel-text">
                <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
              </td>
              <td class="uportal-channel-text" width="100%">
                <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="optionMenuMoveChannel">
    <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
      <tr class="uportal-background-light">
        <td class="uportal-channel-text">
          <p>
            <span class="uportal-channel-subtitle-reversed">Optionen um diesen Channel zu bewegen:</span>
          </p>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="uportal-channel-text">
                <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
              </td>
              <td class="uportal-channel-text">
                <a href="#">Wählen Sie einen der hervorgehobenen Positionen unten aus, oder wählen Sie eine andere Tabelle aus wo Sie dieser Channel plaziert werden soll</a>
              </td>
            </tr>
            <tr>
              <td class="uportal-channel-text" colspan="2">
                <hr/>
              </td>
            </tr>
            <tr>
              <td class="uportal-channel-text">
                <img alt="Schnittstellenbild" src="{$mediaPath}/bullet.gif" width="16" height="16" border="0"/>
              </td>
              <td class="uportal-channel-text" width="100%">
                <a href="{$baseActionURL}?action=cancel">Abbrechen und Zurück</a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="optionMenuError">
    <table width="100%" border="0" cellspacing="0" cellpadding="10" class="uportal-background-content">
      <tr class="uportal-background-light">
        <td class="uportal-channel-text">
          <p>
            <span class="uportal-channel-subtitle-reversed">Der folgende Fehler wurde berichtet:</span>
          </p>
          <xsl:value-of select="$errorMessage"/>
        </td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>



<!-- Stylesheet edited using Stylus Studio - (c)1998-2002 eXcelon Corp. --><!-- Stylesheet edited using Stylus Studio - (c)1998-2002 eXcelon Corp. -->