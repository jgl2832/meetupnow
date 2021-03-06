<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="meetupnow.UserInfo" %>
<%@ page import="meetupnow.RegDev" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>
<%@ page import="org.json.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="meetupnow.OAuthServlet" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Meetup Now</title>
	<link rel="stylesheet" href="css/reset.css" type="text/css" />
	<link rel="stylesheet" href="css/meetupnow.css" type="text/css" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script type="text/javascript" src="/js/container.js"></script>
	<script type="text/javascript">

		
		function loadEvents(){
		<%@ include file="jsp/cookie.jsp" %>
		<%@ include file="jsp/declares.jsp" %>

		<%

		String c_id = "";
		String c_name = "";
		String MUID = "";

		
		if (request.getQueryString() != null) {
			c_id = request.getQueryString();
		} else {
			c_id = "654";
		}
		RegDev sg = new RegDev();
		if (!key.equals("empty")) {
			try {
				users = (List<MeetupUser>) query.execute(key);
				if (users.iterator().hasNext()) {
					MUID = users.get(0).getID();
					Token accessToken = new Token(users.get(0).getAccToken(),users.get(0).getAccTokenSecret());
					API_URL = "http://api.meetup.com/ew/events/?status=upcoming&container_id="+c_id+"&page=20&fields=rsvp_count";
					APIrequest = new Request(Request.Verb.GET, API_URL);
					scribe.signRequest(APIrequest,accessToken);
					APIresponse = APIrequest.send();
					JSONObject json = new JSONObject();
					JSONArray results;
					try {
						json = new JSONObject(APIresponse.getBody());
						results = json.getJSONArray("results");
						c_name = results.getJSONObject(0).getJSONObject("container").getString("name");
						for (int i = 0; i < results.length(); i++) {
							if (users.get(0).isAttending(results.getJSONObject(i).getString("id"))) {
								results.getJSONObject(i).put("attending", "yes");
							} else {
								results.getJSONObject(i).put("attending", "no");
							}				
						}
					}
					catch (JSONException j){

					}
					%>var data = <%=json.toString()%><%
				}
			}
			finally {

			}
		}
		else {

			API_URL = "http://api.meetup.com/ew/events?status=upcoming&radius=25.0&order=time&page=20&fields=rsvp_count&container_id="+c_id;
			APIrequest = new Request(Request.Verb.GET, sg.generateURL(API_URL));
			APIresponse = APIrequest.send();
			%>var data = <%=APIresponse.getBody().toString()%><%
	
		}
		%>
			use_everywhere(data);
		}

	</script>
</head>
<body id="meetupNowBody" onload="loadEvents()">

<%@ include file="jsp/header.jsp" %>

<div id="wrapper">
<div id="wrapperContent">
	<div id="contentRight">
		
		<%
				Query userQuery = pm.newQuery(UserInfo.class);
				userQuery.setFilter("user_id == idParam");
				userQuery.declareParameters("String idParam");
				try {
					List<UserInfo> profiles = (List<UserInfo>) userQuery.execute(MUID);
					if (profiles.size() > 0) {
						String[] groups = profiles.get(0).getGroupArray();
						if (profiles.get(0).isMember(c_id)) {
		%>
		<a href="/UserPrefs.jsp">You recieve notifications from this group!</a>
		<%
						}
						else {
		%>
		<a href="/setprefs?id=<%=users.get(0).getID()%>&action=add&callback=<%=request.getRequestURI()+"?"+request.getQueryString()%>&group=<%=c_id %>">Receive notifications from this group</a>
		<%
						}
					}
				} finally {
					userQuery.closeAll();
				}

		%>
		
	</div> <!-- end #contentRight -->
	<div id="contentLeft">
		<div id="contentLeftContext">
			<div class="map_contextLeft">
				<span class="map_title title">Events in <%=c_name%></span>
				<div id="map_canvasContainerLeft">
					<div id="map_canvas">

					</div><!-- end #map_canvas -->
				</div><!-- end #map_canvasContainer -->
			</div><!-- end .map_context -->
		</div> <!-- end #contentLeftContext -->
	</div> <!-- end #contentLeft -->
</div> <!-- end #wrapperContent -->
</div> <!-- end #wrapper -->



<%@ include file="jsp/footer.jsp" %>
</body>
</html>
