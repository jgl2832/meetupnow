<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="meetupnow.Topic" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>

<%@ page import="org.compass.core.*" %>


<form action="/search.jsp" method="get">
	<input type="text" name="q" value="" size="50" />
	<input type="submit" value="search" />
</form>

<%


	CompassSearchSession search = PMF.getCompass().openSearchSession();


	String query = request.getParameter("q");
if (query != null) {
	CompassHits hits = null;
	hits = search.queryBuilder().queryString(query).toQuery().setTypes(Topic.class).hits();
	//hits = search.find(query);	

%>
<p>Found <%=hits.length() %> hits for query <% out.write(query); %> </p>
<%
		for (int i = 0; i < hits.length(); i++){
			Topic topic = (Topic) hits.data(i);
			Resource resource = hits.resource(i);
%>
<p><a href="/Group?<%=topic.getId() %>"> <%=topic.getName() %> </a></p>

<%
		}
if (hits.getSuggestedQuery().isSuggested()) {
    System.out.println("Did You Mean: " + hits.getSuggestedQuery());
}

	}

%>
