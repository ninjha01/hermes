import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

class ExerciseCreateForm extends Component {
    constructor(props) {
	super(props);
	
	this.state.videoURL = "";
	this.error = null;
    }

    onSubmit = event => {
	const fields =  {"title": this.state.title,
			 "equipment": this.state.equipment,
			 "instructions": this.state.instructions,
			 "primaryVideoID": this.state.primaryVideoID,
			 "reps": this.state.reps,
			 "sets": this.state.sets}

	this.props.firebase
	    .doUpdateExerciseByID(this.state.uid, fields)
	    .catch(error => {
		this.setState({ error: error });
	    });	
	
	const videoFile = this.refs.videoUpload.files[0]


	//refreshing().then(function(result) { process Result }).catch(function(err) {}
    
	this.props.firebase.storage.ref("exercise_videos/").child(fields.primaryVideoID).put(videoFile)

	event.preventDefault();
    };

    onChange = event => {
	
	this.setState({ [event.target.name]: event.target.value });
    };

    render() {
	
	const [title, videoID, videoURL,
	       instructions, equipment, reps,
	       sets, error ] = [this.state.title, this.state.primaryVideoID,
				this.state.videoURL, this.state.instructions,
				this.state.equipment, this.state.reps,
				this.state.sets, this.state.error ];

	this.props.firebase.storage.ref('exercise_videos/').child(videoID)
	    .getDownloadURL()
	    .then((result) => 
		  this.setState({ videoURL: result }));
	
	const isInvalid = false;

	return (
		<form onSubmit={this.onSubmit}>
		
		<span>
		<strong>Title:</strong>
		<input name="title" value={title} onChange={this.onChange} type="text" placeholder="Title" />
		<br></br>
		</span>

		<span>
		<video width="500px" controls src={videoURL} onChange={this.onChange} />
		<input ref="videoUpload" text="Update Video" onChange={this.onChange} type="file" accept='.mp4'/>
		</span>
		<br></br>
		
		<span>		
		<strong>Instructions:</strong>
		<input name="instructions" value={instructions} onChange={this.onChange} type="text" placeholder="Instructions" />
		<br></br>
		</span>

		<span>
		<strong>Equipment:</strong>
		<input name="equipment" value={equipment} onChange={this.onChange} type="text" placeholder="Equipment" />
		<br></br>
		</span>

		<span>
		<strong>Reps:</strong>
		<input name="reps" value={reps} onChange={this.onChange} type="text" placeholder="Reps" />
		<br></br>
		</span>

	    	<span>
		<strong>Sets:</strong>
		<input name="sets" value={sets} onChange={this.onChange} type="text" placeholder="Sets" />
		<br></br>
		</span>
		
		<button disabled={isInvalid} type="submit">Update</button>
		
	    {error && <p>{error.message}</p>}
	    </form>
	);
    }
}

export default withFirebase(ExerciseCreateForm);
