package meetupnow;

import com.google.appengine.api.datastore.Key;

import org.scribe.oauth.Token;

import java.util.ArrayList;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import java.util.StringTokenizer;

@PersistenceCapable
public class MeetupUser {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;

	@Persistent
	private String reqToken;

	@Persistent
	private String reqTokenSecret;

	@Persistent
	private String accToken;

	@Persistent
	private String accTokenSecret;

	@Persistent
	private String name;

	@Persistent
	private String mu_id;

	@Persistent
	private String events;	//A single string of event IDs, seperated by commas

	@Persistent
	private String lat;

	@Persistent
	private String lon;

	@Persistent
	private ArrayList<String> KeyWords;

	public MeetupUser() {
		reqToken = null;
		reqTokenSecret = null;
		accToken = null;
		accTokenSecret = null;
		name = null;
		mu_id = null;
		lat = null;
		lon = null;
		events = "";
		KeyWords = new ArrayList<String>();
	}

	public String [] getKeyWords(){
		return (String []) KeyWords.toArray();
	}
	
	public void addKeyWord(String word){
		this.KeyWords.add(word);
	}

   	public Key getKey() {
    	    	return key;
    	}

	public String getLat() {
		return lat;
	}

	public String getLon() {
		return lon;
	}
	
	public void setLat(String l) {
		lat = l;
	}

	public void setLon(String l) {
		lon = l;
	}

	public String getReqToken() {
		return reqToken;
	}

	public String getReqTokenSecret() {
		return reqTokenSecret;
	}

	public void setReqToken(String r) {
		reqToken = r;
	}

	public void setReqTokenSecret(String a) {
		reqTokenSecret = a;
	}


	public String getAccToken() {
		return accToken;
	}

	public String getAccTokenSecret() {
		return accTokenSecret;
	}

	public void setAccToken(String r) {
		accToken = r;
	}

	public void setAccTokenSecret(String a) {
		accTokenSecret = a;
	}

	public String getName() {
		return name;
	}

	public void setName(String n) {
		name = n;
	}

	public String getID() {
		return mu_id;
	}

	public void setID(String n) {
		mu_id = n;
	}

	public void addEvent(String ev_id) {
		String temp = events.concat(ev_id+",");
		events = temp;
	}

	public String getEventString() {
		return events;
	}

	public String[] getEvents() {
		StringTokenizer st = new StringTokenizer(events,",");
		String[] output = new String[st.countTokens()];
		int i = 0;
		while (st.hasMoreTokens()) {
			output[i] = st.nextToken();
			i++;
		}
		return output;
	}

	//Returns true if user is attending given event
	public boolean isAttending(String ev_id) {
		if (ev_id != null) {
			StringTokenizer st = new StringTokenizer(events,",");
			while (st.hasMoreTokens()) {
				if (st.nextToken().equals(ev_id)) {
					return true;
				}
			}
			return false;
		}
		else return false;
	}

	public void removeEvent(String ev_id) {
		//TO DO
	}
}
