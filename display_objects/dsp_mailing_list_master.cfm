<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfsilent>
	<cfquery datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#" name="variables.rslist">
	select mlid, name, description from tmailinglist where siteid='#variables.$.event('siteID')#' and isPublic=1 order by isPurge, name
	</cfquery>
</cfsilent>

<cfoutput>
<div id="svMasterEmail">
	<cfif variables.$.event('doaction') eq 'masterSubscribe'>
		<cfif variables.$.event("passedProtect")>
			<p class="response success">#variables.$.rbKey('mailinglist.selectionssaved')#</p>
		<cfelse>
			<p class="error">#variables.$.rbKey('captcha.spam')#</p>
		</cfif>
	<cfelseif variables.$.event('doaction') eq 'validateMember'>
		<cfset application.mailinglistManager.validateMember(variables.$.event().getAllValues())/>
		<p class="response success">#variables.$.rbKey('mailinglist.hasbeenvalidated')#</p>
	<cfelse>

		<form id="frmEmailMaster" name="frmEmailMaster" action="?nocache=1" method="post" onsubmit="return validate(this);" novalidate="novalidate" >
			<fieldset>
				<legend>#variables.$.rbKey('mailinglist.mydetails')#</legend>
				<div class="control-group">
					<label class="control-label" for="txtNameFirst">#variables.$.rbKey('mailinglist.fname')#<ins> (#variables.$.rbKey('mailinglist.required')#)</ins></label>
		    		<div class="controls">
						<input id="txtNameFirst" placeholder="#variables.$.rbKey('mailinglist.fname')#" type="text" name="fname" maxlength="50" required="true" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.fnamerequired'))#" />
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="txtNameLast">#variables.$.rbKey('mailinglist.lname')#<ins> (#variables.$.rbKey('mailinglist.required')#)</ins></label>
		    		<div class="controls">
						<input id="txtNameLast" placeholder="#variables.$.rbKey('mailinglist.lname')#" type="text" name="lname" maxlength="50" required="true" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.lnamerequired'))#" />
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="txtCompany">#variables.$.rbKey('mailinglist.company')#</label>
		    		<div class="controls">
						<input id="txtCompany" placeholder="#variables.$.rbKey('mailinglist.company')#" type="text" name="company" maxlength="50" />
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="txtEmail">#variables.$.rbKey('mailinglist.email')#<ins> (#variables.$.rbKey('mailinglist.required')#)</ins></label>
		    		<div class="controls">
						<input id="txtEmail" placeholder="#variables.$.rbKey('mailinglist.email')#" type="text" name="email" maxlength="50" required="true" validate="email" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.emailvalidate'))#" />
					</div>
				</div>
			</fieldset>

			<fieldset>
				<legend>Subscription Settings</legend>
				<div id="subSettings">
					<cfset variables.loopcount = 1>
					<cfloop query="variables.rslist">
						<div class="control-group">
							<div class="controls">
								<label class="checkbox" for="mlid#variables.loopcount#">
								<input id="mlid#variables.loopcount#" type="checkbox" name="mlid" value="#variables.rslist.mlid#" <cfif listfind(variables.$.event('mlid'),variables.rslist.mlid)>checked="checked"</cfif> />#variables.rslist.name#</label>
								<cfif #variables.rslist.description# neq ''><p class="help-block">#variables.rslist.description#</p></cfif>
							</div>
						</div>
						<cfset variables.loopcount = variables.loopcount + 1>
					</cfloop>
				</div>
			</fieldset>

			<div class="control-group">
				<div class="controls">
					<input type="hidden" name="siteid" value="#variables.$.event('siteID')#" />
					<input type="hidden" name="doaction" value="masterSubscribe" />
					<input type="hidden" name="linkServID" value="#variables.$.content('contentID')#" />
					<button type="submit" class="btn" />#HTMLEditFormat(variables.$.rbKey('mailinglist.submit'))#</button>
				</div>
			</div>
			<cfoutput>#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#</cfoutput>
		</form>
	</cfif>
</div>
</cfoutput>