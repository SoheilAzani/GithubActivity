package ecs189.querying.github;

import ecs189.querying.Util;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Vincent on 10/1/2017.
 */
public class GithubQuerier {

    private static final String BASE_URL = "https://api.github.com/users/";

    public static String eventsAsHTML(String user) throws IOException, ParseException {
        List<JSONObject> response = getEvents(user);
        StringBuilder sb = new StringBuilder();
        sb.append("<div>");
        for (int i = 0; i < response.size(); i++) {
            JSONObject event = response.get(i);
            JSONObject payload = event.getJSONObject("payload");
            JSONArray commits = payload.getJSONArray("commits");


            // Get event type
            String type = event.getString("type");
            // Get created_at date, and format it in a more pleasant style
            String creationDate = event.getString("created_at");
            SimpleDateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
            SimpleDateFormat outFormat = new SimpleDateFormat("dd MMM, yyyy");
            Date date = inFormat.parse(creationDate);
            String formatted = outFormat.format(date);

            // Add type of event as header

            //    if (type.equals("PushEvent")){
            sb.append("<h3 class=\"type\">");
            //s    sb.append("example");
            sb.append(i+1 + " ");
            sb.append(type);
            sb.append("</h3>");
            for (int j = 0; j < commits.length(); j++){
                //   JSONObject commit = commits.getJSONObject(j);
                String sha = commits.getJSONObject(j).getString("sha");
                String message = commits.getJSONObject(j).getString("message");
                sb.append("commit: ");
                sb.append(sha);
                sb.append("<br /><div class=\"well\" style=\"width: 350px\";>");
                sb.append(message);
                sb.append("</div>");
            }

            // Add formatted date
            sb.append(" on ");
            sb.append(formatted);
            sb.append("<br />");
            // Add collapsible JSON textbox (don't worry about this for the homework; it's just a nice CSS thing I like)
            sb.append("<a data-toggle=\"collapse\" href=\"#event-" + i + "\">JSON</a>");
            sb.append("<div id=event-" + i + " class=\"collapse\" style=\"height: auto;\"> <pre>");
            sb.append(event.toString());
            sb.append("</pre></div>");
            //  }


        }
        sb.append("</div>");
        return sb.toString();
    }

    private static List<JSONObject> getEvents(String user) throws IOException {
        List<JSONObject> eventList = new ArrayList<JSONObject>();
        String url = BASE_URL + user + "/events";
        System.out.println(url);
        JSONObject json = Util.queryAPI(new URL(url));
        System.out.println(json);
        JSONArray events = json.getJSONArray("root");
//        for (int i = 0; i < events.length() && i < 10; i++) {
//            eventList.add(events.getJSONObject(i));
//        }
        int i = 0;
        int pushes = 0;
        while(pushes < 10){
            if (i == events.length()) break;
            if(events.getJSONObject(i).getString("type").equals("PushEvent")){
                eventList.add(events.getJSONObject(i));
                pushes++;
            }

            i++;
        }
        return eventList;
    }
}